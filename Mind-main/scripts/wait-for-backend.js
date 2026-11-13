/**
 * Espera o backend responder antes de subir o app Flutter.
 *
 * O `flutter run` leva bastante tempo compilando, mas se o app abrir antes
 * do Spring Boot estar de pé a primeira tela mostra erro de conexão. Este
 * script simplesmente enquete GET /psicologos (endpoint público) até
 * responder, com um limite de tempo.
 *
 * Uso: node scripts/wait-for-backend.js [url] [segundos]
 */

const url = process.argv[2] || 'http://localhost:8080/psicologos';
const limiteSegundos = Number(process.argv[3] || 120);

const inicio = Date.now();

async function tentar() {
  try {
    const resposta = await fetch(url);
    if (resposta.ok) return true;
  } catch {
    // Backend ainda subindo — segue tentando.
  }
  return false;
}

(async () => {
  process.stdout.write('Aguardando o backend em ' + url + ' ');

  while ((Date.now() - inicio) / 1000 < limiteSegundos) {
    if (await tentar()) {
      console.log('\nBackend no ar. Subindo o app...');
      process.exit(0);
    }
    process.stdout.write('.');
    await new Promise((r) => setTimeout(r, 2000));
  }

  console.error(
    '\nO backend nao respondeu em ' + limiteSegundos + 's. ' +
      'Verifique se o MongoDB (local ou Atlas, conforme backend/.env) esta acessivel ' +
      'e veja o log do painel BACK.'
  );
  process.exit(1);
})();
