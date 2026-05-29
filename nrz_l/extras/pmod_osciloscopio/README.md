# Extra - Saída pelo PMOD (Osciloscópio)

Disponibiliza o sinal modulado em um pino do conector PMOD da placa, permitindo visualizar a forma de onda em um osciloscópio físico.

## Estrutura desta pasta

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
- Osciloscópio (mínimo 10 MHz)
- Cabo BNC ou pontas de prova para conectar ao PMOD

## Como reproduzir

Ver o [tutorial completo](./docs/Tutorial_NRZL_PMOD.pdf), que descreve:
1. Conexão física do osciloscópio ao pino do PMOD
2. Gravação do bitstream
3. Configuração da escala do osciloscópio
4. Captura da forma de onda