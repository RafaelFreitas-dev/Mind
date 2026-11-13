/**
 * reset-db.js
 * Apaga todas as coleções do MongoDB (psicologos, pacientes, horarios, agendas).
 * O DataInitializer do backend vai recriar os dados de seed automaticamente
 * na próxima vez que o servidor subir.
 *
 * Usa o MESMO banco do backend: a MONGODB_URI do arquivo backend/.env (ou da
 * variável de ambiente MONGODB_URI). Sem ela, usa o MongoDB local.
 *
 * Quando o banco é o MongoDB Atlas (online), ele é compartilhado com todo o
 * grupo — por isso o script pede confirmação antes de apagar.
 *
 * Uso: npm run reset:db
 *      npm run reset:db -- --sim   (apaga sem perguntar)
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { MongoClient } = require('mongodb');

const DB_NAME = 'mindDB';

// Coleções que serão apagadas (dados de runtime)
const COLLECTIONS_TO_DROP = ['psicologos', 'pacientes', 'horarios', 'agendas'];

function lerMongoUri() {
  if (process.env.MONGODB_URI) return process.env.MONGODB_URI.trim();

  const arquivoEnv = path.join(__dirname, 'backend', '.env');
  if (!fs.existsSync(arquivoEnv)) return null;

  const linha = fs
    .readFileSync(arquivoEnv, 'utf8')
    .replace(/^﻿/, '')
    .split(/\r?\n/)
    .map((l) => l.trim())
    .find((l) => l.startsWith('MONGODB_URI='));

  return linha ? linha.slice('MONGODB_URI='.length).trim() : null;
}

const MONGO_URL = lerMongoUri() || 'mongodb://localhost:27017';
const BANCO_LOCAL = /^mongodb:\/\/(localhost|127\.0\.0\.1)/.test(MONGO_URL);

// Mostra o endereço sem usuário e senha.
const ENDERECO_SEM_SENHA = MONGO_URL.replace(/\/\/[^@/]+@/, '//***@');

function perguntar(pergunta) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  return new Promise((resolve) => {
    rl.question(pergunta, (resposta) => {
      rl.close();
      resolve(resposta.trim());
    });
  });
}

async function resetDb() {
  console.log(`Banco: ${BANCO_LOCAL ? 'MongoDB local' : 'MongoDB Atlas (online)'} - ${ENDERECO_SEM_SENHA}`);

  if (!BANCO_LOCAL && !process.argv.includes('--sim')) {
    const resposta = await perguntar(
      'Isso vai APAGAR os dados do banco ONLINE, que é compartilhado com todo o grupo.\n' +
        'Digite APAGAR para confirmar: '
    );
    if (resposta !== 'APAGAR') {
      console.log('Cancelado. Nada foi apagado.');
      return;
    }
  }

  const client = new MongoClient(MONGO_URL);

  try {
    await client.connect();
    console.log('Conectado ao MongoDB.');

    const db = client.db(DB_NAME);
    const existingCollections = (await db.listCollections().toArray()).map(c => c.name);

    for (const col of COLLECTIONS_TO_DROP) {
      if (existingCollections.includes(col)) {
        await db.collection(col).drop();
        console.log(`  ✓ Coleção '${col}' apagada.`);
      } else {
        console.log(`  - Coleção '${col}' não existe, ignorando.`);
      }
    }

    console.log('\nReset concluído! Reinicie o backend para re-popular com os dados iniciais.');
  } catch (err) {
    console.error('Erro ao resetar o banco de dados:', err);
    process.exitCode = 1;
  } finally {
    await client.close();
  }
}

resetDb();
