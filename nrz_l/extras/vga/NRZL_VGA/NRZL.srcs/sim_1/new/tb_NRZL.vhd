-- ============================================================
-- tb_NRZL.vhd  -  Testbench CORRIGIDO para NRZL_Source (Basys3)
--
-- PROBLEMAS DO TESTBENCH ORIGINAL:
--   1. ciclos => 50_000_000 tornaria a simulação inviável
--      (cada bit levaria 500 ms de tempo simulado;
--       16 bits completos = 8 segundos de simulação)
--   2. Um único pulso de btn curto (20 ns) não atravessa o
--      debounce interno (que exige btn estável por 500_000 ciclos)
--   3. A lógica de toggle não foi considerada: o source usa
--      btn como toggle - 1º clique INICIA, 2º clique PAUSA
--
-- CORREÇÕES APLICADAS:
--   • ciclos => 2  → cada bit dura 20 ns (2 ciclos de clock)
--     → 16 bits completos simulados em ~320 ns
--   • BTN_PRESS = 80 ns → btn mantido alto por tempo suficiente
--     para atravessar o contador de debounce quando DEBOUNCE_MAX
--     é reduzido para teste (veja nota no source)
--   • Fluxo completo: idle → 1º clique → modulação → 2º clique
--     → troca de vetor → 3º clique → nova modulação
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_NRZL is
end tb_NRZL;

architecture Behavioral of tb_NRZL is

    -- ── Parâmetros de temporização ────────────────────────────

    -- DEVE ser igual ao generic map abaixo
    -- Use 2 para simulação; restaure 50_000_000 só para síntese
    constant CICLOS    : integer := 2;

    -- Período do clock (100 MHz = 10 ns, igual à Basys3)
    constant CLK_PER   : time := 10 ns;

    -- Tempo total de 1 bit transmitido
    constant BIT_TIME  : time := CICLOS * CLK_PER;   -- 20 ns

    -- Duração do pulso do botão
    -- O debounce interno usa DEBOUNCE_MAX ciclos de clock.
    -- Para simulação com DEBOUNCE_MAX = 5 (valor de teste no source),
    -- BTN_PRESS = 80 ns (8 ciclos) é suficiente para atravessá-lo.
    -- Se mantiver DEBOUNCE_MAX = 500_000, aumentar BTN_PRESS para 5 ms.
    constant BTN_PRESS : time := 80 ns;

    -- Pausa entre ações do operador
    constant PAUSE     : time := 40 ns;

    -- ── Sinais do DUT ─────────────────────────────────────────
    signal clk      : STD_LOGIC := '0';
    signal btn      : STD_LOGIC := '0';
    signal o_swv    : STD_LOGIC_VECTOR(15 downto 0) := "1010010110100101";
    signal nrzl_out : STD_LOGIC;
    signal leds_out : STD_LOGIC_VECTOR(15 downto 0);

begin

    -- ════════════════════════════════════════════════════════
    -- Geração de clock
    -- Alterna a cada metade do período → 100 MHz
    -- ════════════════════════════════════════════════════════
    clk <= not clk after CLK_PER / 2;

    -- ════════════════════════════════════════════════════════
    -- Instância do DUT
    -- ════════════════════════════════════════════════════════
    DUT : entity work.NRZL_Source
        generic map (
            -- NÃO use 50_000_000 aqui - a simulação nunca terminaria
            -- Use sempre CICLOS (= 2) para o testbench
            ciclos => CICLOS
        )
        port map (
            clk      => clk,
            btn      => btn,
            o_swv    => o_swv,
            nrzl_out => nrzl_out,
            leds_out => leds_out
        );

    -- ════════════════════════════════════════════════════════
    -- Processo de estímulos
    -- Simula o operador pressionando o botão e alterando chaves
    -- ════════════════════════════════════════════════════════
    process
    begin

        -- ── FASE 1: Estado inicial ─────────────────────────────
        -- reset interno = '1' (source já inicializa assim)
        -- btn = '0', nenhuma ação do operador
        -- Esperado: leds_out = "0000000000000000", nrzl_out = '0'
        report "FASE 1: Sistema em reset. Aguardando 1o clique.";
        wait for PAUSE;

        -- ── FASE 2: 1º clique - inicia modulação ──────────────
        -- Toggle: reset '1' -> '0'
        -- Ação:   captura o_swv = "1010010110100101"
        -- Resultado: leds_out espelha o vetor capturado;
        --            nrzl_out percorre os bits sequencialmente
        report "FASE 2: 1o clique -> modulacao iniciada.";
        report "  Vetor: 1010010110100101";
        report "  Esperado leds_out: 1010010110100101";
        btn <= '1';
        wait for BTN_PRESS;   -- mantém pressionado para atravessar debounce
        btn <= '0';

        -- Aguarda transmissão dos 16 bits completos
        -- (16 × BIT_TIME = 16 × 20 ns = 320 ns)
        wait for 16 * BIT_TIME + PAUSE;

        -- ── FASE 3: 2º clique - pausa modulação ───────────────
        -- Toggle: reset '0' -> '1'
        -- Resultado: leds_out zera, nrzl_out congela em '0'
        report "FASE 3: 2o clique -> modulacao pausada.";
        report "  Esperado leds_out: 0000000000000000";
        btn <= '1';
        wait for BTN_PRESS;
        btn <= '0';
        wait for PAUSE;

        -- ── FASE 4: Operador altera as chaves ─────────────────
        -- Durante reset, o novo vetor pode ser configurado livremente
        -- O sistema ignora as chaves até o próximo clique
        report "FASE 4: Chaves alteradas para 1111000011110000.";
        o_swv <= "1111000011110000";
        wait for PAUSE;

        -- ── FASE 5: 3º clique - reinicia com novo vetor ───────
        -- Toggle: reset '1' -> '0'
        -- Ação:   captura o_swv = "1111000011110000"
        -- Resultado: leds_out espelha o novo vetor;
        --            nrzl_out reinicia sequência do bit 0
        report "FASE 5: 3o clique -> nova modulacao com 1111000011110000.";
        report "  Esperado leds_out: 1111000011110000";
        btn <= '1';
        wait for BTN_PRESS;
        btn <= '0';

        -- Aguarda transmissão completa do novo vetor
        wait for 16 * BIT_TIME + PAUSE;

        report "SIMULACAO CONCLUIDA.";
        wait;

    end process;

end Behavioral;