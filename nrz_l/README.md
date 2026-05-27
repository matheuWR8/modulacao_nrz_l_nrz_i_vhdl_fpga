# Modulação NRZ-L

Implementação em VHDL da modulação Unipolar NRZ-L, em que o bit é representado pelo nivel do pulso durante todo o intervalo do bit (1 = nivel alto, 0 = nivel baixo).

## Estrutura desta pasta

```
nrz_l/
|-- src/ Código-fonte VHDL do circuito
|-- sim/ Testbench para simulação
|-- constraints/ Mapeamento dos pinos da FPGA (.xdc)
|-- vivado_project/ Projeto Vivado pronto para abrir
|-- docs/ Tutoriais e documentação técnica
`-- extras/ Atividades opcionais (PMOD e VGA)
```

## Arquivos de código

- `src/NRZL_Source.vhd` - código-fonte do circuito principal
- `sim/tb_NRZL.vhd` - testbench para simulação
- `constraints/basys_nrzl.xdc` - mapeamento dos pinos da FPGA

## Documentação

[SUBSTITUIR]
- [Tutorial de simulação](./docs/tutorial_simulacao.pdf) - como simular no Vivado passo a passo
- [Tutorial de gravação na placa](./docs/tutorial_placa.pdf) - como sintetizar, gerar bitstream e gravar na FPGA
- [Documentação técnica](./docs/documentacao_projeto.pdf) - diagrama de blocos, descrição das portas e funcionamento

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):
1. Abrir o Vivado e carregar `vivado_project/NRZL.xpr`
2. Clicar em `Run Simulation` -> `Run Behavioral Simulation`

Para **reproduzir o projeto do zero**, siga esta ordem:
[SUBSTITUIR]
1. **Entenda o circuito** lendo a [documentação técnica](./docs/documentacao_projeto.pdf)
2. **Simule no Vivado** seguindo o [tutorial de simulação](./docs/tutorial_simulacao.pdf)
3. **Grave na placa** seguindo o [tutorial de gravação](./docs/tutorial_placa.pdf)