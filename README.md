# NEORICALEX

[![Build Status](https://www.travis-ci.com/neoricalex/neoricalex.svg?branch=master)](https://www.travis-ci.com/neoricalex/neoricalex)

## Início Rápido

### Requisitos

* Uma Distribuição Linux Ubuntu >= 18.04 LTS
* Um computador compatível com ambientes virtualizados, com capacidade mínima de uma máquina virtual com 4096 de RAM, 100 GB de espaço em disco, e 3 CPU's

### AVISO: USE POR SUA PRÓPRIA CONTA E RISCO

O [NEORICALEX](https://neoricalex.com.br) é um pouco intrusivo e pode danificar seu sistema operacional e/ou pasta raiz, criando e/ou modificando várias pastas, discos e partições.

Recomendo vivamente que você teste em uma VM antes de tentar em um sistema que você usa no dia a dia.

Embora espere que não faça nada completamente terrível, você pode desejar ver os script's antes de executá-los, e certifique-se de que o backup do seu sistema, e da pasta raiz, seja feito por precaução!

### Como iniciar

```bash
# Instalar o Git
sudo apt install git -y

# Clonar o NEORICALEX
git clone https://github.com/neoricalex/neoricalex.git

# Entrar na pasta neoricalex
cd neoricalex

# Iniciar
bash shell

# Dados para o NFDOS:
#   Usuário:    neo
#   Senha:      neoricalex
```

## O que são os projetos NEORICALEX & NFDOS
Embora completamente interligados, o NFDOS e NEORICALEX são dois projetos diferentes.

### NFDOS
O NFDOS significa Neo Free Disk Operating System, e é um Sistema Operativo criado do zero.

Eu não sei você, mas eu sempre quis saber como se faz um sistema operacional do zero. Mas isso apenas não bastava. Eu também queria saber como se faz um sistema de distribuição completo, onde eu digitava um comando ou dois, e eu tinha uma imagem ISO gerada para poder distribuir o meu sistema, ou usar em qualquer computador.

Mas tudo isso apenas não bastava. Eu também queria ter o contrôle total, assim como saber o que estava a fazer. Os "Hello World's" são bastante bons, mas melhor ainda, é saber o que acontece, e o que faz com que o "Hello World" funcione.

Se você também está buscando por isso, o NFDOS é para você.

Originalmente, o NFDOS foi pensado para servir de aprendizado, uma vez que o NFDOS está a ser desenvolvido por um Iniciante em Assembly e C. Com toda a certeza que não seria possível do NFDOS ser uma realidade sem a preciosa ajuda de:

* O [Operating System Development Series](http://www.brokenthorn.com/Resources/);
* O [OSDev](https://wiki.osdev.org/Main_Page);
* O [Linux From Scratch](http://www.linuxfromscratch.org/);
* O [Minimal Linux Live (MLL)](https://github.com/ivandavidov/minimal);
* O [Buildroot](https://buildroot.org/);
* E o [MIT xv6 OS](https://pdos.csail.mit.edu/6.828/2019/)

Por outras palavras, o NFDOS não é uma ferramenta para fazer coisas por você. O NFDOS é uma ferramenta do tipo DIY - Do It Yourself - para você aprender a fazer você mesmo. Você lê o código, vê como se faz, e reproduz da forma que você bem quiser e entender.

No entanto, em Fevereiro 2020, eu fiquei desempregado com a pandemia do COVID19. Foi preciso encontrar uma forma de pagar as contas ao final do mês e, decidi de monetizar meu conhecimento trabalhando em meu próprio projeto pessoal.

E foi assim então dessa forma, que o NEORICALEX passou de um projeto em modo "Hobbye", para modo "Produção".

Para levar a bom termo esse projeto, eu vou precisar de um Desktop para criar/desenvolver o código, e, um Servidor para hospedar na cloud.

Fazer a Placa-Mãe, Memória RAM, e todas as outras partes físicas do Desktop e Servidor, eu não vou conseguir saber fazer. Mas o Sistema Operativo, e todo o Software que o Desktop e/ou o Servidor vão precisar para funcionarem, aí já tenho uma palavra a dizer.

### NEORICALEX
O [NEORICALEX](https://neoricalex.com.br) é então, a minha Plataforma e/ou Ambiente de Trabalho. O local onde eu condenso tudo o que eu sei fazer em TI.

O [NEORICALEX](https://neoricalex.com.br) é um framework de trabalho com 3 ambientes:
* **Ambiente de Desenvolvimento**
    * Um Ambiente baseado no Vagrant com o NFDOS instalado, que vamos usar para desenvolver todo o projeto. 
      * ( O Computador Pessoal e/ou o VPS de Desenvolvimento Local)
* **Ambiente de Homologação**
    * Um Ambiente baseado no Virtualbox que vamos usar para testarmos o projeto. 
      * ( O VPS de Staging Local )
* **Ambiente de Produção**
    * Um Ambiente baseado na Cloud (Digital Ocean, Google Cloud, IBM, etc) para fazermos o Deploy do Projeto. 
      * ( O VPS Remoto )

A minha ideia principal para o projeto [NEORICALEX](https://neoricalex.com.br) é **criar os 3 ambientes com apenas um comando**, e depois vender o conhecimento através de um curso online, a que dei o nome de **COPED**.

Para conseguir chegar nesse objetivo, eu originalmente tinha decidido de criar uma Distribuição Linux do Zero. No entanto, como já falei, fiquei desempregado com a maldita pandemia, então na verdade isso passou a ser o meu "sonho". Por enquanto preciso monetizar. Então eu optei por seguir o atalho de criar um "Ubuntu from scratch".

Começar do completo Zero demanda tempo que eu não tenho. Preciso monetizar para depois sim, ir indo no encontro de um SO do Zero no sentido literal do conceito.

Para já, a grande vantagem que pretendo, é trabalhar em "Real Time". Ou seja, tudo o que for feito, será sincronizado em tempo real, ou bem próximo disso. Dessa forma poderá até rebentar uma bomba nuclear que o trabalho estará sempre salvo e sincronizado.

Por outras palavras, eu não comecei no Assembly. Comecei bem mais na frente, criando uma versão customizada do Ubuntu 20.04 do completo zero. Dessa forma economizo um bom tempo.

O [NEORICALEX](https://neoricalex.com.br) pode ser visto como:

* Uma ferramenta para criar uma Distribuição [Linux](https://www.kernel.org/) do Zero baseada no [Ubuntu](https://ubuntu.com/).
    * Nessa Distribuição a que dei o nome NFDOS, existe, ou vai existir:
        * Uma Firewall
        * Um Proxy Reverso
        * Um Load Balancer
        * Um Cluster LXC/LXD
        * Um Cluster Docker
        * Um Cluster Kubernetes
        * Uma VPN
        * E muito mais...

O detalhe é, como já comentei, eu quero que **tudo seja feito com um único comando**.

Dessa forma, **com apenas um comando**, em caso de catástrofe, a imagem ISO estará pronta com tudo o que é necessário para que o [NEORICALEX](https://neoricalex.com.br) funcione, sem que para isso eu tenha de instalar software, atualizar, e/ou fazer lá seja aquilo que fôr. 

Será algo tipo "Plug n Play". Colocar o CD/DVD no Leitor, arrancar o Desktop/Notebook ou o Servidor/VPS pelo Live CD/DVD e pronto. O Sistema está no Ar e pronto a executar aquilo que quisermos que ele execute.

Gostou da ideia?

## Roadmap

### Ambiente de Desenvolvimento
#### Fase Inicial
##### Criação de um VM de Desenvolvimento (VPS_DEV)
- [x] Criar um Sistema de LOG
- [x] Instalar o Vagrant
- [x] Criar uma box do vagrant com o Ubuntu 20.04 (ubuntu/focal64)
  - [x] Criar a imagem ISO do NFDOS 
  - [x] Criar uma imagem .box com o NFDOS instalado (NFDOS-x.x.x.box)
  - [x] Criar uma imagem de disco .vmdk com o NFDOS instalado (NFDOS-disk001.vmdk)
  - [x] Enviar para a Vagrant Cloud a .box (NFDOS-x.x.x.box) com o NFDOS Instalado (neoricalex/nfdos)
- [x] Criar o VPS_DEV baseado na box neoricalex/nfdos

##### Criação de um Ambiente de Integração Contínua (CI) no Travis (VPS_TRAVIS)
- [x] Criar um processo CI
  - [x] Configurar o auto-inicio da máquina do Travis
  - [x] Instalar o QEMU & Vagrant
  - [ ] Criar uma box padrão do vagrant com o Ubuntu 18.04 (generic/ubuntu1804)
    - [ ] Instalar o Git, clonar o NEORICALEX, entrar na pasta neoricalex, e iniciar executando o bash shell 

#### Segunda Fase: Configuração base do VPS_DEV
- [ ] Instalar o Docker Engine, Docker Compose & Docker Machine no VPS_DEV
  - [ ] Criar um Cluster Docker Swarm
    - [ ] Criar um container master from scratch
    - [ ] Criar uma Docker Machine Master Remota (Digital Ocean, IBM, Google, Azure, AWS, Etc...)
    - [ ] Criar uma Docker Machine Leader Local (No VPS_DEV)
      - [ ] Criar um Cluster Kubernetes
          - [ ] Criar um Stack Wordpress (Será apenas uma Demo)
      - [ ] Criar um container para a Documentação do Projeto
      - [ ] Criar um container Docker Registry Local (No VPS_DEV)
      - [ ] Criar um container Gitlab
      - [ ] Criar um container Email Server
      - [ ] Criar um container NextCloud  
      - [ ] Criar um Stack Wordpress (Será o Stack de Produção)
          - [ ] Maiores infos em breve

#### Terceira Fase: Desenvolvimento dos Projetos NEORICALEX & NFDOS
- [ ] Criar um Workflow: VPS_DEV >> VPS_STAGING >> VPS_PROD
  - [ ] Maiores infos em breve

### Ambiente de Homologação
Maiores infos em breve

### Ambiente de Produção
Maiores infos em breve

## Financiamento

Gostou da ideia, e está afim de ajudar em seu desenvolvimento financeiramente?
Ajude via [Paypal](https://www.paypal.me/AleexFL).

Obrigado desde já pelo "café" :-)

## Documentação
Maiores infos em breve.

## Licença

[LICENÇA PÚBLICA GERAL GNU (Versão 2, junho de 1991)](./LICENSE)
