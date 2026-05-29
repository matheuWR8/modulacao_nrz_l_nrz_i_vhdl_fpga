# Extra - Saída pelo VGA

Disponibiliza o sinal modulado pelo saída de VGA da placa, permitindo visualizar a os níveis produzidos pela modulação alternando cores na tela de um display conectado.

## Estrutura desta pasta

```
pmod_osciloscopio/
|-- src/
 Código VHDL adaptado com saída no VGA
|-- constraints/
 Constraint com mapeamento dos pinos do VGA e dados do monitor e das cores
`-- docs/
 Tutorial e capturas do display
```

## Equipamentos necessários

- Placa FPGA xc7a35tcpg236-1
- Cabo VGA
- Display com entrada VGA

## Como reproduzir

Ver o [tutorial completo](./docs/Tutorial_NRZL_VGA.pdf), que descreve:
1. Conexão física do cabo VGA
2. Gravação do bitstream
3. Exibição da oscilação das cores no monitor-