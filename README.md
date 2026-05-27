# Modulação Digital em VHDL

Trabalho da disciplina de Comunicação de Dados - Sistemas Reconfiguraveis, ministrada pelo professor doutor Vinicius Borges. Semestre 2026/1.

## Integrantes

- Nome 1
- Nome 2

## Descrição

Este trabalho implementa, em VHDL, dois sistemas de modulacao digital: Unipolar NRZ-L e Unipolar NRZ-I. O codigo foi simulado no Vivado Simulator e implementado na placa xc7a35tcpg236-1.

## Estrutura do repositório

```
modulacao_vhdl/
|-- nrz_l/ Projeto da modulação NRZ-L (auto-contido)
|-- nrz_i/ Projeto da modulação NRZ-I (auto-contido)
`-- relatorio_final/ Relatório técnico consolidado e vídeo demo
```

Cada projeto possui sua própria pasta `docs/` com tutoriais e documentação técnica, e uma pasta `extras/` com as atividades opcionais (saída PMOD e saída VGA).

## Projetos

- [Modulação NRZ-L](./nrz_l/) - bit representado pelo nível do pulso
- [Modulação NRZ-I](./nrz_i/) - bit representado pela transição do pulso

## Relatório

- [Relatório técnico final](./relatorio_final/relatorio.pdf)
- [Vídeo de demonstração](./relatorio_final/video_demo.mp4)

## Ferramentas utilizadas

- Vivado 2023.1
- Placa xc7a35tcpg236-1
- Osciloscópio (apenas para o extra do PMOD)

## Como começar

Recomendamos iniciar pelo projeto NRZ-L. Acesse a pasta [nrz_l/](./nrz_l/) e siga o README local.