# Extra - Saída pelo VGA

Disponibiliza o sinal modulado pelo saída de VGA da placa, permitindo visualizar a os níveis produzidos pela modulação alternando cores na tela de um display conectado.

## Estrutura desta pasta [ADAPTAR AO VGA]

```
pmod_osciloscopio/
|-- src/
 Código VHDL adaptado com saída no PMOD
|-- constraints/
 Constraint com mapeamento do pino PMOD
`-- docs/
 Tutorial e capturas do osciloscópio
```

## Equipamentos necessários

- Placa FPGA xc7a35tcpg236-1
- Cabo VGA
- Display com entrada VGA

## Como reproduzir [ADAPTAR AO VGA]

Ver o [tutorial completo](./docs/tutorial_pmod.pdf), que descreve:
1. Conexão física do osciloscópio ao pino do PMOD
2. Gravação do bitstream
3. Configuração da escala do osciloscópio
4. Captura da forma de onda