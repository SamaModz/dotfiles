import { Mistral } from '@mistralai/mistralai';
import { createInterface } from 'readline';
import { exec } from 'child_process';
import dotenv from 'dotenv';
dotenv.config()

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
const apiKey = process.env.MISTRAL_API_KEY || 'yljao8GiwLUYjje4h5JgWkDAd6ouMZvn';
if (!apiKey) {
  throw new Error('Chave da API não encontrada. Configure a variável de ambiente MISTRAL_API_KEY.');
}
const client = new Mistral({ apiKey });

const rl = createInterface({
  input: process.stdin,
  output: process.stdout,
});

async function run() {
  const you = `${white}[${blue}You${white}] ❯${darkblue} `;
  const ai = `${white}[${orange}MISTRAL${white}] ❯ ${orange_bg} `;

  async function askAndRespond() {
    rl.question(you, async (msg) => {
      if (msg.toLowerCase() === 'exit') {
        rl.close();
      } else if (msg.toLowerCase() === 'clear') {
        exec('clear')
      } else {
        try {
          const chatResponse = await client.chat.complete({
            model: 'mistral-large-latest',
            messages: [{ role: 'user', content: msg }],
          });

          const responseText = chatResponse.choices[0].message.content;
          console.log('\n' + ai, responseText + reset + '\n');
        } catch (error) {
          console.error(`${red}Erro ao obter resposta:${error + reset}`);
        } finally {
          askAndRespond();
        }
      }
    });
  }

  askAndRespond();
}

run();
