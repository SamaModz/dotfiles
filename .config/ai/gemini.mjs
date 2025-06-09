import { GoogleGenerativeAI } from '@google/generative-ai';
import { createInterface } from 'readline';
import dotenv from 'dotenv';
// Carrega as variáveis de ambiente do arquivo .env
dotenv.config();

// Cores para formatação de texto no terminal
const colors = {
  red: '\x1b[1;91m',
  green: '\x1b[1;92m',
  blue: '\x1b[1;94m',
  yellow: '\x1b[1;92m',
  cyan: '\x1b[1;95m',
  purple: '\x1b[1;96m',
  white: '\x1b[1;97m',
  reset: '\x1b[0m',
  darkblue: '\x1b[1;38;2;146;152;164m',
  orange: '\x1b[1;38;2;208;135;112m',
  orange_bg: '\x1b[4m',
};

const { red, green, blue, yellow, cyan, purple, white, reset, darkblue, orange, orange_bg } = colors;

const genAI = new GoogleGenerativeAI(
  process.env.GOOGLE_API_KEY
);
const rl = createInterface({
  input: process.stdin,
  output: process.stdout,
});

/**
 * Exibe um indicador de loading fixo enquanto a operação assíncrona é executada e depois imprime o resultado.
 * @param {Function} asyncOperation - Função assíncrona que retorna uma Promise.
 * @returns {Promise<any>} - Retorna o resultado da operação assíncrona.
 */
async function loadingInLine(asyncOperation) {
  process.stdout.write(`${green}Loading...${reset}\r`);

  try {
    const result = await asyncOperation();
    process.stdout.write('\r\x1b[K'); // Limpa a linha do loading
    console.log(result); // Imprime a resposta sem animação
    return result;
  } catch (error) {
    process.stdout.write('\r\x1b[K'); // Limpa a linha do loading
    console.error(`✖ Erro: ${error.message}`);
    throw error;
  }
}

async function run() {
  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

  const chat = model.startChat({
    history: [],
    generationConfig: {
      // maxOutputTokens: 500,
    },
  });

  const you = `${white}[${blue}You${white}] ❯${darkblue} `;
  const ai = `${white}[${cyan}Gemini${white}] ❯${green}`;

  async function askAndRespond() {
    rl.question(you, async (msg) => {
      if (msg.toLowerCase() === "exit") {
        rl.close();
      } else {
        // Exibe o loading enquanto a mensagem é enviada e a resposta é recebida
        await loadingInLine(async () => {
          const result = await chat.sendMessage(process.argv[2] || msg);
          const response = await result.response;
          return `${ai} ${await response.text()}`;
        });

        // Chama recursivamente para continuar o chat
        askAndRespond();
      }
    });
  }
  askAndRespond();
}

run();

