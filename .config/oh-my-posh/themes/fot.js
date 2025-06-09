const fs = require('fs');
const path = require('path');

const colorsFile = path.resolve('colors.json');
const themeFile = path.resolve('theme.omp.json');

const coresPadrao = ['#e5e5e5', '#cccccc', '#999999', '#666666', '#333333', '#262626'];

// HEX <-> RGB <-> HSL helpers
function hexToRgb(hex) {
  hex = hex.replace(/^#/, '');
  const bigint = parseInt(hex, 16);
  return [ (bigint >> 16) & 255, (bigint >> 8) & 255, bigint & 255 ];
}

function rgbToHex(r, g, b) {
  return '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('');
}

function rgbToHsl(r, g, b) {
  r /= 255; g /= 255; b /= 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  let h, s, l = (max + min) / 2;
  if (max === min) h = s = 0;
  else {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break;
      case g: h = (b - r) / d + 2; break;
      case b: h = (r - g) / d + 4; break;
    }
    h /= 6;
  }
  return [h, s, l];
}

function hslToRgb(h, s, l) {
  const hue2rgb = (p, q, t) => {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1/6) return p + (q - p) * 6 * t;
    if (t < 1/2) return q;
    if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
    return p;
  };
  if (s === 0) return [l, l, l].map(v => Math.round(v * 255));
  const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  const p = 2 * l - q;
  const r = hue2rgb(p, q, h + 1/3);
  const g = hue2rgb(p, q, h);
  const b = hue2rgb(p, q, h - 1/3);
  return [r, g, b].map(v => Math.round(v * 255));
}

// Gera tons a partir da cor base
function gerarTons(hexBase, n = 6) {
  const [r, g, b] = hexToRgb(hexBase);
  const [h, s, l] = rgbToHsl(r, g, b);
  return Array.from({ length: n }, (_, i) => {
    const step = l - (i * l / (n - 1));
    const [r2, g2, b2] = hslToRgb(h, s, step);
    return rgbToHex(r2, g2, b2);
  });
}

// Substitui cores
function substituirCores(json, buscar, substituir) {
  let novo = json;
  buscar.forEach((cor, i) => {
    const regex = new RegExp(cor, 'gi');
    novo = novo.replace(regex, substituir[i]);
  });
  return novo;
}

// Carrega ou cria arquivo de cores
function carregarCores() {
  if (!fs.existsSync(colorsFile)) {
    const dados = {
      original: coresPadrao,
      current: coresPadrao
    };
    fs.writeFileSync(colorsFile, JSON.stringify(dados, null, 2));
    return dados;
  }
  return JSON.parse(fs.readFileSync(colorsFile, 'utf8'));
}

function salvarCores(dados) {
  fs.writeFileSync(colorsFile, JSON.stringify(dados, null, 2));
}

// Executa update ou reset
function main() {
  if (!fs.existsSync(themeFile)) {
    console.error('theme.omp.json não encontrado.');
    process.exit(1);
  }

  const args = process.argv;
  const conteudo = fs.readFileSync(themeFile, 'utf8');
  const cores = carregarCores();

  if (args.includes('--reset')) {
    console.log('Resetando para cores originais...');
    const atualizado = substituirCores(conteudo, cores.current, cores.original);
    fs.writeFileSync(themeFile, atualizado, 'utf8');
    cores.current = [...cores.original];
    salvarCores(cores);
    console.log('Reset concluído.');
    return;
  }

  const idx = args.indexOf('--color');
  if (idx === -1 || !args[idx + 1]) {
    console.error('Uso:\n  node update-theme.js --color "#rrggbb"\n  node update-theme.js --reset');
    process.exit(1);
  }

  const novaCor = args[idx + 1];
  const hexBase = novaCor.startsWith('#') ? novaCor : `#${novaCor}`;
  if (!/^#[0-9a-fA-F]{6}$/.test(hexBase)) {
    console.error('Cor inválida. Use formato #rrggbb');
    process.exit(1);
  }

  const novosTons = gerarTons(hexBase, cores.original.length);
  const atualizado = substituirCores(conteudo, cores.current, novosTons);
  fs.writeFileSync(themeFile, atualizado, 'utf8');

  cores.current = novosTons;
  salvarCores(cores);
  console.log('Tema atualizado com nova cor base:', hexBase);
}

main();
