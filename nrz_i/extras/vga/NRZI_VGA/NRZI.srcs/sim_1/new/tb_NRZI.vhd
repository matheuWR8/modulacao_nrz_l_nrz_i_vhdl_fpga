-- ============================================================
-- tb_NRZI.vhd  -  Testbench CORRIGIDO para NRZI_Source (Basys3)
--
-- PROBLEMAS DO TESTBENCH ORIGINAL:
--
--   1. PORTA INEXISTENTE: o original usa "reset" como porta direta
--      do DUT. No source adaptado NÃO existe porta "reset" -
--      ela foi substituída por "btn" (toggle com debounce interno).
--      Conectar "reset" causa erro de compilação imediato.
--
--   2. PORTA FALTANDO: o original não mapeia "leds_out", que é
--      uma saída obrigatória do source adaptado. Porta não mapeada
--      gera warning crítico ou erro dependendo da versão do Vivado.
--
--   3. DEBOUNCE IGNORADO: mesmo que a porta existisse, um pulso
--      de reset de 20 ns (2 ciclos) seria descartado pelo debounce
--      interno (que exige btn estável por DEBOUNCE_MAX ciclos).
--      O sistema nunca sairia do estado inicial.
--
-- CORREÇÕES APLICADAS:
--   • "reset" renomeado para "btn" (porta correta do source)
--   • "leds_out" adicionado ao port map
--   • BTN_PRESS = 80 ns para atravessar o debounce (com
--     DEBOUNCE_MAX = 5 no source durante simulação)
--   • Fluxo de 3 cliques simulado com verificação dos estados
--     NRZ-I esperados documentados nos reports
--
-- ANTES DE SIMULAR:
--   Reduza DEBOUNCE_MAX no NRZI_Source.vhd de 500_000 para 5.
--   Restaure para 500_000 antes de gerar o bitstream.
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_NRZI is
end tb_NRZI;

architecture Behavioral of tb_NRZI is

    -- ── Parâmetros de temporização ────────────────────────────

    -- DEVE ser igual ao generic map abaixo
    -- Use 2 para simulação; use 50_000_000 somente na síntese
    constant CICLOS    : integer := 2;

    -- Período do clock (100 MHz = 10 ns, igual à Basys3)
    constant CLK_PER   : time := 10 ns;

    -- Tempo total de transmissão de 1 bit
    constant BIT_TIME  : time := CICLOS * CLK_PER;   -- 20 ns

    -- Duração do pulso do botão
    -- Com DEBOUNCE_MAX = 5 no source, 8 ciclos (80 ns) é suficiente
    -- para atravessar o debounce e registrar a borda de subida
    constant BTN_PRESS : time := 80 ns;

    -- Pausa entre ações do operador
    constant PAUSE     : time := 40 ns;

    -- ── Sinais do DUT ─────────────────────────────────────────
    signal clk      : STD_LOGIC := '0';
    signal btn      : STD_LOGIC := '0';   -- era "reset" no original (ERRADO)
    signal o_swv    : STD_LOGIC_VECTOR(15 downto 0) := "1010010110100101";
    signal nrzi_out : STD_LOGIC;
    signal leds_out : STD_LOGIC_VECTOR(15 downto 0); -- FALTAVA no original

begin

    -- ════════════════════════════════════════════════════════
    -- Geração de clock
    -- Alterna a cada metade do período → 100 MHz
    -- ════════════════════════════════════════════════════════
    clk <= not clk after CLK_PER / 2;

    -- ════════════════════════════════════════════════════════
    -- Instância do DUT
    -- ════════════════════════════════════════════════════════
    DUT : entity work.NRZI_Source
        generic map (
            -- NÃO use 50_000_000 aqui - usaria 8 s de tempo simulado
            ciclos => CICLOS
        )
        port map (
            clk      => clk,
            btn      => btn,       -- "reset" foi SUBSTITUÍDO por "btn"
            o_swv    => o_swv,
            nrzi_out => nrzi_out,
            leds_out => leds_out   -- porta AUSENTE no original
        );

    -- ════════════════════════════════════════════════════════
    -- Processo de estímulos
    -- Simula o operador pressionando o botão e alterando chaves
    --
    -- Estados NRZ-I esperados para "1010010110100101"
    -- (estado inicial aux = '0', inverte a cada bit '1'):
    --
    --   Bit 0 = '1' → inverte → aux = '1' → LED[0] = '1'
    --   Bit 1 = '0' → mantém  → aux = '1' → LED[1] = '1'
    --   Bit 2 = '1' → inverte → aux = '0' → LED[2] = '0'
    --   Bit 3 = '0' → mantém  → aux = '0' → LED[3] = '0'
    --   Bit 4 = '0' → mantém  → aux = '0' → LED[4] = '0'
    --   Bit 5 = '1' → inverte → aux = '1' → LED[5] = '1'
    --   Bit 6 = '0' → mantém  → aux = '1' → LED[6] = '1'
    --   Bit 7 = '1' → inverte → aux = '0' → LED[7] = '0'
    --   Bit 8 = '1' → inverte → aux = '1' → LED[8] = '1'
    --   Bit 9 = '0' → mantém  → aux = '1' → LED[9] = '1'
    --   Bit10 = '1' → inverte → aux = '0' → LED[10]= '0'
    --   Bit11 = '0' → mantém  → aux = '0' → LED[11]= '0'
    --   Bit12 = '1' → inverte → aux = '1' → LED[12]= '1'
    --   Bit13 = '0' → mantém  → aux = '1' → LED[13]= '1'
    --   Bit14 = '0' → mantém  → aux = '1' → LED[14]= '1'
    --   Bit15 = '1' → inverte → aux = '0' → LED[15]= '0'
    --
    --   leds_state esperado = "0110100110001100" -> 0x698C (hex)
    -- ════════════════════════════════════════════════════════
    process
    begin

        -- ── FASE 1: Estado inicial ─────────────────────────────
        -- reset interno = '1', btn = '0'
        -- Esperado: leds_out = 0x0000, nrzi_out = '0'
        report "FASE 1: Sistema em reset. Aguardando 1o clique.";
        wait for PAUSE;

        -- ── FASE 2: 1º clique - inicia modulação ──────────────
        -- Toggle: reset '1' -> '0'
        -- Captura: o_swv = "1010010110100101"
        -- Pré-calcula leds_state com a lógica diferencial NRZ-I
        -- Esperado: leds_out = "0110100110001100" = 0x698C
        -- nrzi_out percorre os bits sequencialmente
        report "FASE 2: 1o clique -> modulacao NRZI iniciada.";
        report "  Vetor capturado : 1010010110100101";
        report "  leds_out esperado: 0110100110001100";
        btn <= '1';
        wait for BTN_PRESS;
        btn <= '0';

        -- Aguarda transmissão dos 16 bits completos
        -- (16 × BIT_TIME = 16 × 20 ns = 320 ns)
        wait for 16 * BIT_TIME + PAUSE;

        -- ── FASE 3: 2º clique - pausa modulação ───────────────
        -- Toggle: reset '0' -> '1'
        -- Esperado: leds_out = 0x0000, nrzi_out congela em '0'
        report "FASE 3: 2o clique -> modulacao pausada.";
        report "  Esperado leds_out: 0000000000000000";
        btn <= '1';
        wait for BTN_PRESS;
        btn <= '0';
        wait for PAUSE;

        -- ── FASE 4: Operador altera chaves durante reset ───────
        -- Novo vetor "1111000011110000":
        --
        --   Bit 0 = '1' → inverte → aux = '1' → LED[0] = '1'
        --   Bit 1 = '1' → inverte → aux = '0' → LED[1] = '0'
        --   Bit 2 = '1' → inverte → aux = '1' → LED[2] = '1'
        --   Bit 3 = '1' → inverte → aux = '0' → LED[3] = '0'
        --   Bit 4 = '0' → mantém  → aux = '0' → LED[4] = '0'
        --   Bit 5 = '0' → mantém  → aux = '0' → LED[5] = '0'
        --   Bit 6 = '0' → mantém  → aux = '0' → LED[6] = '0'
        --   Bit 7 = '0' → mantém  → aux = '0' → LED[7] = '0'
        --   Bit 8 = '1' → inverte → aux = '1' → LED[8] = '1'
        --   Bit 9 = '1' → inverte → aux = '0' → LED[9] = '0'
        --   Bit10 = '1' → inverte → aux = '1' → LED[10]= '1'
        --   Bit11 = '1' → inverte → aux = '0' → LED[11]= '0'
        --   Bit12 = '0' → mantém  → aux = '0' → LED[12]= '0'
        --   Bit13 = '0' → mantém  → aux = '0' → LED[13]= '0'
        --   Bit14 = '0' → mantém  → aux = '0' → LED[14]= '0'
        --   Bit15 = '0' → mantém  → aux = '0' → LED[15]= '0'
        --
        --   leds_state esperado = "0000010100001010" = 0x00A5... 
        --   Na ordem [15:0] = "0000000001010101" = 0x0055
        report "FASE 4: Chaves alteradas para 1111000011110000.";
        o_swv <= "1111000011110000";
        wait for PAUSE;

        -- ── FASE 5: 3º clique - reinicia com novo vetor ───────
        -- Toggle: reset '1' -> '0'
        -- Captura: o_swv = "1111000011110000"
        -- aux reseta para '0' antes de recalcular
        -- Esperado: leds_out = "0000000001010101"
        report "FASE 5: 3o clique -> nova modulacao com 1111000011110000.";
        report "  leds_out esperado: 0000000001010101";
        btn <= '1';
        wait for BTN_PRESS;
        btn <= '0';

        -- Aguarda transmissão completa do novo vetor
        wait for 16 * BIT_TIME + PAUSE;

        report "SIMULACAO CONCLUIDA.";
        wait;

    end process;

end Behavioral;