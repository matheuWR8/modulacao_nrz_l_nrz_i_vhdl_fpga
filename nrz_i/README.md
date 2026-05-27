# Modulação NRZ-I

Implementação em VHDL da modulação Unipolar NRZ-I, em que o bit
é representado pela transição do pulso no início do intervalo
de bit (1 = inversão do nível, 0 = mantém o nível anterior).

## Estrutura desta pasta

```
nrz_i/
|-- src/ Código-fonte VHDL do circuito
|-- sim/ Testbench para simulação
|-- constraints/ Mapeamento dos pinos da FPGA (.xdc)
|-- vivado_project/ Projeto Vivado pronto para abrir
|-- docs/ Tutoriais e documentação técnica
`-- extras/ Atividades opcionais (PMOD e VGA)
```

## Arquivos de código

- `src/NRZI_Source.vhd` - código-fonte do circuito principal
- `sim/tb_NRZI.vhd` - testbench para simulação
- `constraints/basys3_NRZI.xdc` - mapeamento dos pinos da FPGA

## Documentação

[SUBSTITUIR]
- [Tutorial de simulação](./docs/tutorial_simulacao.pdf) -
como simular no Vivado passo a passo
- [Tutorial de gravação na placa](./docs/tutorial_placa.pdf) -
como sintetizar, gerar bitstream e gravar na FPGA
- [Documentação técnica](./docs/documentacao_projeto.pdf) -
diagrama de blocos, descrição das portas e funcionamento

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):
1. Abrir o Vivado e carregar `vivado_project/NRZI.xpr`
2. Clicar em `Run Simulation` -> `Run Behavioral Simulation`

Para **reproduzir o projeto do zero**, siga esta ordem:
[SUBSTITUIR]
1. **Entenda o circuito** lendo a
[documentação técnica](./docs/documentacao_projeto.pdf)
2. **Compare com o NRZ-L** (vimos no projeto anterior) para
identificar as diferenças na lógica de transição
3. **Simule no Vivado** seguindo o
[tutorial de simulação](./docs/tutorial_simulacao.pdf)
4. **Grave na placa** seguindo o
[tutorial de gravação](./docs/tutorial_placa.pdf)
5. (Opcional) Explore os
[extras](./extras/) - PMOD e VGA

## Extras (opcionais)

- [Saída pelo PMOD para osciloscópio](./extras/pmod_osciloscopio/)
- [Saída VGA com cores pulsantes](./extras/vga/)

## Próximo passo

Você concluiu os dois projetos do trabalho. Agora acesse o
[Relatório técnico final](../relatorio_final/relatorio.pdf)
para ver a análise comparativa entre NRZ-L e NRZ-I, os
resultados obtidos e as conclusões do grupo.