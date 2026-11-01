# Clínica Conecta — primeira versão

Painel local para cadastrar pacientes, programar mensagens e enviar lembretes de consultas pelo WhatsApp. Feito para um computador Windows, um usuário e um número de WhatsApp.

## Instalar no Windows

1. Instale o **Node.js 24 LTS** em https://nodejs.org (mantenha a opção de adicionar ao PATH). Se já instalou, feche e reabra o Explorador antes de continuar.
2. Extraia **todo o ZIP** para uma pasta permanente, como `C:\ClinicaConecta`. Não execute os arquivos dentro do ZIP, de uma pasta pública compartilhada ou de uma pasta sincronizada com outros usuários.
3. Dê dois cliques em **INSTALAR.cmd**. Aguarde a mensagem de conclusão. A instalação baixa as dependências pela internet; não precisa de Git nem de Vercel.
4. Abra **INICIAR.cmd**. O navegador abrirá em **http://127.0.0.1:3210**. Crie uma senha de pelo menos 10 caracteres.
5. Entre em **WhatsApp** e escolha **Gerar QR code**. No celular, vá a Dispositivos conectados → Conectar dispositivo e escaneie. Também é possível informar o número completo, gerar o código e usar a opção de vinculação por número no celular. Não é um código SMS.
6. Cadastre um paciente com o WhatsApp completo: por exemplo, `5547999999999`. Marque a autorização de contato somente quando ela existir.
7. Para validar a instalação, cadastre **seu próprio número como paciente de teste**, programe uma mensagem para alguns minutos adiante e confirme o recebimento antes de cadastrar pacientes reais.

O sistema fica em segundo plano. Fechar o navegador não encerra os envios. Para parar, abra **ENCERRAR.cmd**. Para reabrir o painel, execute INICIAR.cmd novamente; ele identifica o processo existente.

## Uso diário

- **Consultas:** escolha paciente, data/hora, profissional e local. Salvar cria uma confirmação para envio assim que houver conexão, um lembrete 24h antes e outro 2h antes. O agendador verifica a fila a cada 3 segundos, um envio por vez. Os horários não são uma garantia de entrega pelo WhatsApp.
- **Agendamento próximo:** se já faltarem menos de 24h ou de 2h, o lembrete daquela etapa não será criado. A confirmação continua sendo criada.
- **Remarcar:** em Consultas, use Remarcar. Os envios pendentes da versão anterior são cancelados e é criada uma nova confirmação com os novos dados.
- **Cancelar:** cancela a consulta e os envios pendentes. Não envia uma mensagem de cancelamento ao paciente.
- **Mensagens:** escreva um texto e escolha data/hora. O conteúdo será enviado como foi escrito, sem substituição automática de variáveis.
- **Editar paciente:** permite corrigir nome e revogar a autorização. Para trocar o número, cancele antes os envios pendentes. Mensagens já geradas mantêm o nome que estava no texto ao agendar.
- **Horários:** todos os campos usam Brasília, UTC−03:00, mesmo que o computador esteja configurado em outro fuso. Mantenha o relógio do Windows correto.

O campo Local pode conter endereço, instruções ou um link para uma consulta online. Confira os textos gerados no histórico. As respostas dos pacientes chegam no WhatsApp normal; o painel não é uma caixa de entrada e não responde automaticamente.

## Computador ligado

Em Configurações do Windows → Sistema → Energia, configure o computador para **não suspender enquanto estiver conectado à tomada**. A tela pode apagar normalmente. Não há alteração automática das configurações de energia.

**ATIVAR-INICIO-AUTOMATICO.cmd** cria um atalho na Inicialização do usuário. A ferramenta volta a funcionar quando esse usuário entra no Windows, sem abrir o navegador. Não funciona antes do login e não liga o computador sozinha. Para desfazer, use DESATIVAR-INICIO-AUTOMATICO.cmd. Não mova a pasta após ativar; se mover, desative e ative novamente.

Se faltar energia/internet, o computador suspender ou o processo parar, os envios aguardam. Cada mensagem tem **30 minutos de tolerância**, limitada ao início da consulta. Depois disso, fica marcada como Atrasada para revisão. Não há envio automático em massa dos lembretes antigos ao religar.

## Status dos envios

- **Na fila:** aguardando horário ou conexão.
- **Enviando:** tentativa em andamento.
- **Enviada:** o envio ao WhatsApp foi concluído; não significa que o paciente recebeu ou leu.
- **Com falha:** o número não foi localizado no WhatsApp.
- **Conferir envio:** houve interrupção ou resultado incerto. A mensagem pode já ter saído. Confira a conversa antes de clicar em Revisar e reenviar.
- **Atrasada:** a janela de envio passou. Reenvie apenas se ainda fizer sentido.
- **Cancelada:** não será enviada.

Não há repetição automática de tentativas incertas, para reduzir duplicações. Nenhum sistema local consegue garantir exatamente um envio em todas as falhas de rede. Remarcar/cancelar durante um envio pede que você aguarde sua conclusão.

## Dados, senha e backup

O painel escuta somente em `127.0.0.1`: não é acessível por outro computador, celular ou internet. A senha protege o painel, mas não substitui a proteção da conta do Windows e do disco.

Os dados ficam em **data**, na pasta do programa. O instalador restringe o acesso dessa pasta ao usuário atual e ao sistema. O banco contém nomes, números, autorizações, consultas e histórico de mensagens em texto; não armazene detalhes clínicos desnecessários. A sessão do WhatsApp é criptografada com AES-256-GCM, usando uma chave em data/session.key. Quem tiver acesso ao banco e à chave pode acessar essa sessão.

Use **BACKUP.cmd**. Ele gera uma cópia consistente do banco e da chave em **backups**, mesmo com o programa aberto. Copie o backup para um local protegido, de preferência com criptografia. Ele contém dados pessoais e sessão do WhatsApp. Nunca suba data ou backups ao GitHub.

Para restaurar: encerre a ferramenta, preserve a pasta data atual, substitua clinic.sqlite e session.key pelos arquivos do mesmo backup e remova da nova pasta quaisquer arquivos clinic.sqlite-wal / clinic.sqlite-shm antigos antes de iniciar. A senha salva no backup será restaurada. Confira o histórico; envios interrompidos ficam para revisão. Se o WhatsApp pedir, vincule novamente.

## GitHub

O código está pronto para um **repositório privado**. O GitHub não executará o envio contínuo; guardará o projeto e rodará os testes. A publicação na sua conta depende de conectar o GitHub ao ChatGPT ou de você criar um repositório privado e subir os arquivos do projeto.

Inclua package-lock.json, public, src, test, windows, arquivos CMD, documentação, .gitignore e .github/workflows. **Não inclua node_modules, data, backups ou logs**. O .gitignore já contém essas exclusões. GitHub Actions tem uma rotina de testes para Linux e Windows; ela não conecta ao WhatsApp nem envia mensagens.

Para desenvolvimento: `npm ci`, `npm test`, `npm run check` e `npm start`. Exige Node 24 ou superior. Não hospede este servidor na Vercel: ele depende de disco persistente e de processo contínuo.

## Custo e limites desta entrega

O código não cobra assinatura nem tarifa por mensagem. Há consumo de internet e energia do computador. A conexão usa **Baileys, integração não oficial**, e pode deixar de funcionar com mudanças do WhatsApp, desconectar ou sofrer restrições de conta. Não é a API oficial da Meta. Não oferece disparo em massa, garantias de entrega, caixa de entrada ou acesso remoto.

Esta primeira versão passou por testes automatizados de agenda, persistência, acesso e fila usando transporte simulado. A biblioteca Baileys foi instalada e seus exports usados pelo adaptador foram verificados. **Ainda é necessário validar a vinculação e um envio real no seu Windows.** Os scripts Windows foram preparados, mas não executados nesta sessão Linux. Não há validação visual em navegador nesta entrega.

## Problemas comuns

- **Node não encontrado:** instale Node 24 LTS e reabra o terminal/Explorador. Execute INSTALAR.cmd.
- **Não abre:** consulte data/erros.log. A porta 3210 pode estar ocupada. Acesse pelo endereço completo `http://127.0.0.1:3210`, sem substituir por localhost.
- **Conexão sem QR:** clique em Desconectar e gere novamente. Confira a internet e os dispositivos conectados no celular.
- **Mensagens não saem:** confira conexão do WhatsApp, autorização, data/hora, status da fila, internet e suspensão do Windows.
- **Esqueceu a senha:** não há recuperação por e-mail nesta versão. Preserve o backup e solicite suporte para redefinição local, sem apagar o banco de pacientes.

Não exponha a porta com redirecionamento ou túnel para acesso externo: esta versão foi feita para uso local.
