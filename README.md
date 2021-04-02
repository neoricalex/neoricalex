# NEORICALEX

[![Build Status](https://www.travis-ci.com/neoricalex/neoricalex.svg?branch=master)](https://www.travis-ci.com/neoricalex/neoricalex) <!--[![Coverage Status](https://coveralls.io/repos/github/neoricalex/neoricalex/badge.svg?branch=master)](https://coveralls.io/github/neoricalex/neoricalex?branch=master)-->

## Início Rápido

### Requisitos

* Uma Distribuição Linux Ubuntu >= 20.04 LTS
* Um computador compatível com ambientes virtualizados, com capacidade mínima de uma máquina virtual com 6144 de RAM, 128 GB de espaço em disco virtual, e 4 CPU's
  * É possível reduzir a RAM para 4096, assim como o número de núcleos, porém terá de alargar o tempo de compilação em pelo menos 1 hora ou talvez mesmo duas (Não testado)

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

Embora completamente interligados, o NEORICALEX & NFDOS são dois projetos diferentes.

### NEORICALEX

O [NEORICALEX](https://neoricalex.com.br) é a minha Plataforma e/ou Ambiente de Trabalho. O local onde eu condenso tudo o que eu sei fazer em TI.

O [NEORICALEX](https://neoricalex.com.br) é um framework de trabalho com 3 ambientes:

* **Ambiente de Desenvolvimento**
  * Um Ambiente físico com o NFDOS instalado, que vamos usar para desenvolver todo o projeto.
    * ( O Computador Pessoal )
  * Um Ambiente baseado no Vagrant com o NFDOS instalado
    * ( O VPS de Desenvolvimento Local)
* **Ambiente de Homologação**
  * Um Ambiente baseado no Travis que vamos usar para testarmos o projeto.
    * ( O VPS de Staging remoto )
  * Um Ambiente baseado no Virtualbox que vamos usar para testarmos o projeto.
    * ( O VPS de Staging local )
* **Ambiente de Produção**
  * Um Ambiente baseado na Cloud (Digital Ocean, Google Cloud, IBM, etc) para fazermos o Deploy do Projeto.
    * ( O VPS de Produção Remoto )

A minha ideia principal para o projeto [NEORICALEX](https://neoricalex.com.br) é **criar os 3 ambientes com apenas um comando**, e depois vender o conhecimento através de um curso online, a que dei o nome de **COPED**.

Para conseguir chegar nesse objetivo, eu originalmente tinha decidido de criar uma Distribuição Linux do Zero. O NFDOS. No entanto, em Fevereiro 2020, eu fiquei desempregado com a pandemia do COVID19. Foi preciso encontrar uma forma de pagar as contas ao final do mês e, decidi de monetizar meu conhecimento trabalhando em meu próprio projeto pessoal. Com isso, criar uma Distribuição Linux do Zero passou a ser o meu "sonho". Por enquanto preciso monetizar. Então eu decidi seguir o atalho de criar um "Ubuntu from scratch".

Começar do completo Zero demanda tempo que eu não tenho. Preciso monetizar para depois sim, ir indo no encontro de um SO do Zero no sentido literal do conceito.

Para já, a grande vantagem que pretendo, é trabalhar em "Real Time". Ou seja, tudo o que for feito, será sincronizado em tempo real, ou bem próximo disso. Dessa forma poderá até rebentar uma bomba nuclear que o trabalho estará sempre salvo e sincronizado.

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

Para levar a bom termo esse projeto, eu vou precisar de um Desktop para criar/desenvolver o código, e, um Servidor para hospedar na cloud.

Fazer a Placa-Mãe, Memória RAM, e todas as outras partes físicas do Desktop e Servidor, eu não vou conseguir saber fazer. Mas o Sistema Operativo, e todo o Software que o Desktop e/ou o Servidor vão precisar para funcionarem, aí já tenho uma palavra a dizer.

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

No entanto, como já comentei, eu fiquei desempregado com a maldita pandemia. Foi assim então dessa forma, que o NFDOS passou de um projeto em modo "Hobbye", para modo "Produção".

Gostou da ideia?

## Roadmap

### Ambiente de Desenvolvimento

#### Fase Inicial

Nesta primeira fase vamos mitigar ao máximo quaisquer danos no computador fisico que usamos em nosso dia-a-dia, e vamos criar duas box do vagrant.

A primeira, com o Ubuntu Focal, vamos baixar da vagrant cloud (*ubuntu/focal64*). Depois vamos instalar nela as ferramentas necessárias para trabalharmos, Linux Headers, Build Essentials, etc, e vamos enviar de volta para a vagrant cloud com o nome [neoricalex/ubuntu](https://app.vagrantup.com/neoricalex/boxes/ubuntu). Para nós, esta box está referenciada na CLI como *VPS_BASE*.

* [ ] Criar uma box via o Vagrant Cloud com o Ubuntu 20.04 LTS (ubuntu/focal64)
  * [ ] Provisionar com pacotes minimos de desenvolvimento (Linux headers, build-essentials, etc...)
  * [x] Empacotar e enviar a box para a Vagrant Cloud ficando acessivel via [neoricalex/ubuntu](https://app.vagrantup.com/neoricalex/boxes/ubuntu)
  * [x] Excluir/Remover/Deletar localmente a box ubuntu/focal64 pois não será mais necessária.

Depois de termos uma box para trabalhar - [neoricalex/ubuntu](https://app.vagrantup.com/neoricalex/boxes/ubuntu) (*VPS_DEV*) - vamos criar e desenvolver o NFDOS dentro dela, criando uma imagem ISO para usarmos e/ou instalarmos em computadores fisicos, uma imagem VMDK para usarmos no Virtualbox já com o NFDOS instalado e, duas imagens BOX para uso no Vagrant também elas com o NFDOS instalado. As duas BOX para uso no Vagrant estão configuradas da seguinte forma:  

1. Uma configurada para o provider virtualbox. E;
2. Outra configurada com o provider libvirt. Esta iremos também enviar para a vagrant cloud, porém desta vez com o nome *neoricalex/nfdos*.
    1. Para nós, esta box está referenciada na CLI como *NFDOS*.
    2. Esta box será também usada pelo Travis (VPS de Staging Remoto) para homologação do projeto.

* [x] Criar a Distribuição GNU/Linux NFDOS baseada no Ubuntu
  * [x] Criar uma box via a Vagrant Cloud [neoricalex/ubuntu](https://app.vagrantup.com/neoricalex/boxes/ubuntu) (VPS_DEV)
    * [x] Criar a imagem ISO do NFDOS (*nfdos.iso*)
      * [x] Gerar a *initramfs*
        * [x] Configurar
      * [x] Gerar o *rootfs*
        * [x] Configurar
      * [x] Gerar o *bootloader*
        * [x] Configurar
      * [x] Gerar a imagem ISO
    * [x] Criar duas imagens BOX do Vagrant, uma para o provider virtualbox, outra para o provider libvirt, e ambas com o NFDOS instalado (*NFDOS-x.x.x.box*)
      * [x] BOX para o Virtualbox
        * [x] Gerar a imagem de disco .vmdk com o NFDOS instalado (*src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS-disk001.vmdk*)
          * [x] Arrancar via *src/vps/nfdos/core/nfdos.iso*
          * [x] Instalar o NFDOS
        * [x] Gerar o arquivo .ovf (*src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS.ovf*)
        * [x] Gerar a *src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS-x.x.x.box*
      * [x] BOX para o Libvirt
        * [x] Gerar a *src/vps/nfdos/desktop/vagrant/libvirt/NFDOS-x.x.x.box*
          * [x] Arrancar via *src/vps/nfdos/core/nfdos.iso*
          * [x] Instalar o NFDOS
        * [X] Enviar a box para a Vagrant Cloud ficando acessivel via *neoricalex/nfdos*. (Esta box será também a usada pelo Travis)

Ao final da primeira fase ficaremos com:
* Uma imagem ISO localizada em: *src/vps/nfdos/core/nfdos.iso*
* Uma imagem VMDK localizada em: *src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS-disk001.vmdk*
* Uma imagem OVF localizada em: *src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS.ovf*
* Uma imagem BOX para o provider libvirt do Vagrant localizada em: *src/vps/nfdos/desktop/vagrant/libvirt/NFDOS-x.x.x.box*
* Uma imagem BOX para o provider virtualbox do Vagrant localizada em: *src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS-x.x.x.box*
* Um VPS do Vagrant identificado na CLI como VPS_BASE com todas as ferramentas necessárias para trabalharmos localizada em: *src/vps/vagrant-libs/base.box*
* Um VPS do Vagrant identificado na CLI como VPS_DEV dísponivel online via a Vagrant Cloud no endereço: *neoricalex/ubuntu*
  * Dentro do VPS_DEV:
    * Um VPS do Vagrant para o provider virtualbox com o NFDOS instalado
      * Será usado como VPS de Staging Local
      * É a BOX localizada em *src/vps/nfdos/desktop/vagrant/virtualbox/NFDOS-x.x.x.box*
    * Um VPS do Vagrant identificado na CLI como NFDOS para o provider libvirt com o NFDOS instalado
      * Será usada como VPS de Staging Remoto (No Travis)
      * Ficará dísponivel online via a Vagrant Cloud no endereço: *neoricalex/nfdos*
      * É a BOX localizada em *src/vps/nfdos/desktop/vagrant/libvirt/NFDOS-x.x.x.box*

#### Segunda Fase

Maiores infos em breve

* [ ] Desenvolver a Distribuição GNU/Linux NFDOS baseada no Ubuntu
  * [ ] Configurar as Ferramentas de Desenvolvimento
    * [ ] Clonar o repositório do QEMU
      * [ ] Configurar
      * [ ] Compilar
    * [ ] Clonar o repositório do Packer
      * [ ] Configurar
      * [ ] Compilar
    * [ ] Clonar o repositório do Vagrant
      * [ ] Configurar
      * [ ] Compilar
    * [ ] Clonar o repositório do Vagrant-Libvirt
      * [ ] Configurar
      * [ ] Compilar
  * [ ] Configurar o Firmware do NFDOS (Tiano Core EDK II)
    * [ ] Clonar o repositório do Tiano Core
    * [ ] Configurar
    * [ ] Compilar
  * [ ] Configurar o Bootloader do NFDOS (GRUB 2)
    * [ ] Clonar o repositório da GRUB 2
    * [ ] Configurar
    * [ ] Compilar
  * [ ] Configurar o Kernel do NFDOS (Linux)
    * [ ] Clonar o repositório da Linux
    * [ ] Configurar
    * [ ] Compilar
  * [ ] Desenvolver a *initramfs*
  * [ ] Desenvolver o *rootfs*
    * [ ] Instalar o Docker Engine, Docker Compose & Docker Machine no NFDOS
    * [ ] Criar um Cluster Docker Swarm
      * [ ] Criar uma Docker Machine Master Remota (Digital Ocean, IBM, Google, Azure, AWS, Etc...)
        * [ ] Instalar um container com o Wireguard Server
      * [ ] Criar uma Docker Machine Leader Local (No NFDOS)
        * [ ] Criar um Stack Wordpress (Será o Stack de Produção)
          * [ ] Maiores infos em breve
        * [ ] Criar um Cluster Kubernetes
          * [ ] Criar um Stack Wordpress (Será apenas uma Demo)
        * [ ] Criar um container para a Documentação do Projeto
        * [ ] Criar um container Docker Registry Local (No NFDOS)
        * [ ] Criar um container Gitlab
        * [ ] Criar um container Email Server
        * [ ] Criar um container NextCloud  
        * [ ] Criar um container from scratch
    * [ ] Personalizações e/ou Customizações

### Ambiente de Homologação

O processo de homologação será feito de duas formas:
1. Vamos criar um VPS de Staging Remoto no Travis, e vamos homologar a geração de todo o sistema. Ou, por outras palavras, vamos homologar a execução do comando *bash shell*.
2. Vamos criar um VPS de Staging Local no Virtualbox, e vamos homologar a experiência do usuário final no modo gráfico (GUI). Ou, por outras palavras, vamos homologar todo o processo de instalação da imagem ISO do NFDOS no Computador.
##### Criação de um VPS de Staging Remoto (Travis)

* [x] Criar um processo CI
  * [x] Configurar o auto-arranque da máquina do Travis via Hook no Github
    * [x] Iniciar a box do vagrant *neoricalex/nfdos*
      * [ ] Auto executar o bash shell

##### Criação de um VPS de Staging local (Virtualbox)

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
