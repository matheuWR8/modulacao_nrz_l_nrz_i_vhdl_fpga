library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================
--  NRZL_Source
--  - Reads 16-bit switch vector on button press
--  - Mirrors the captured word on leds_out
-- =============================================================

entity NRZL_Source is
    Generic (
        ciclos : INTEGER := 50_000_000   -- bit period at 100 MHz
    );
    Port (
        clk      : in  STD_LOGIC;                      -- 100 MHz board clock
        btn      : in  STD_LOGIC;                      -- debounced capture button
        o_swv    : in  STD_LOGIC_VECTOR(15 downto 0);  -- switches

        leds_out : out STD_LOGIC_VECTOR(15 downto 0);  -- LED mirror
        nrzl_out : out STD_LOGIC

    );
end NRZL_Source;

architecture Behavioral of NRZL_Source is

    -- =========================================================
    --  Debounce
    -- =========================================================
    constant DEBOUNCE_MAX : integer := 500_000;

    signal db_cnt     : integer range 0 to DEBOUNCE_MAX := 0;
    signal btn_stable : STD_LOGIC := '0';
    signal btn_prev   : STD_LOGIC := '0';

    -- =========================================================
    --  NRZ-L state
    -- =========================================================
    signal reset_n      : STD_LOGIC := '0';   -- '0' = transmitting, '1' = idle/reset
    signal bit_counter  : integer range 0 to ciclos - 1 := 0;
    signal bit_index    : integer range 0 to 15 := 15;  -- MSB first

    signal captured_swv : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    signal nrzl_reg     : STD_LOGIC := '0';   

begin

    -- =========================================================
    --  Debounce + capture + toggle
    --
    --  On each rising edge of btn_stable (button press):
    --    • Capture o_swv into captured_swv
    --    • Toggle reset_n: '1' stops TX, '0' starts TX
    --  This means the first press captures & starts; the second
    --  press stops; the third press captures fresh & starts, etc.
    -- =========================================================
    p_debounce_toggle : process(clk)
    begin
        if rising_edge(clk) then

            -- Debounce counter
            if btn = btn_stable then
                db_cnt <= 0;
            else
                if db_cnt = DEBOUNCE_MAX - 1 then
                    db_cnt     <= 0;
                    btn_stable <= btn;
                else
                    db_cnt <= db_cnt + 1;
                end if;
            end if;

            btn_prev <= btn_stable;

            -- Rising edge of debounced button
            if btn_stable = '1' and btn_prev = '0' then
                -- Capture switches BEFORE toggling so the just-read
                -- value is always what gets transmitted next
                if reset_n = '1' then
                    -- Was stopped → capture new word and start
                    captured_swv <= o_swv;
                end if;
                reset_n <= not reset_n;
            end if;

        end if;
    end process;

    -- =========================================================
    --  NRZ-L modulation  (synchronous reset, MSB-first)
    --
    --  reset_n = '1'  →  idle: output low, counters cleared
    --  reset_n = '0'  →  transmit: cycle through bits 15..0
    -- =========================================================
    p_nrzl : process(clk)
    begin
        if rising_edge(clk) then

            if reset_n = '1' then
                -- Idle / reset state
                bit_counter <= 0;
                bit_index   <= 15;
                nrzl_reg    <= '0';
                leds_out    <= (others => '0');

            else
                -- Drive current bit
                nrzl_reg <= captured_swv(bit_index);
                leds_out <= captured_swv;

                if bit_counter = ciclos - 1 then
                    bit_counter <= 0;

                    -- Advance to next bit (MSB → LSB, then wrap)
                    if bit_index = 0 then
                        bit_index <= 15;
                    else
                        bit_index <= bit_index - 1;
                    end if;
                else
                    bit_counter <= bit_counter + 1;
                end if;
            end if;

        end if;
    end process;

    nrzl_out <= nrzl_reg;

end Behavioral;