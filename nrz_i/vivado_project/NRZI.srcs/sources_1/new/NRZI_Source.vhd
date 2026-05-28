library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================
--  NRZI_Source
--  - Reads 16-bit switch vector on button press
--  - Mirrors NRZI accumulated states on LEDs
-- =============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NRZI_Source is

    Generic (
        ciclos : INTEGER := 50_000_000
    );

    Port (
        clk      : in  STD_LOGIC;
        btn      : in  STD_LOGIC;

        o_swv    : in  STD_LOGIC_VECTOR(15 downto 0);

        leds_out : out STD_LOGIC_VECTOR(15 downto 0);

        nrzi_out : out STD_LOGIC

    );

end NRZI_Source;

architecture Behavioral of NRZI_Source is

    -- =========================================================
    -- Debounce
    -- =========================================================
    constant DEBOUNCE_MAX : integer := 500_000;

    signal db_cnt       : integer range 0 to DEBOUNCE_MAX := 0;
    signal btn_stable   : STD_LOGIC := '0';
    signal btn_prev     : STD_LOGIC := '0';

    -- =========================================================
    -- NRZI
    -- =========================================================
    signal reset_n      : STD_LOGIC := '1';

    signal bit_counter  : integer range 0 to ciclos - 1 := 0;
    signal bit_index    : integer range 0 to 15 := 15;

    signal aux_signal   : STD_LOGIC := '0';

    signal captured_swv : STD_LOGIC_VECTOR(15 downto 0)
                        := (others => '0');

    signal leds_state   : STD_LOGIC_VECTOR(15 downto 0)
                        := (others => '0');

begin

    -- =========================================================
    -- Debounce + capture + toggle
    -- =========================================================
    p_debounce_toggle : process(clk)

        variable acc : STD_LOGIC;
        variable k   : integer;

    begin
        if rising_edge(clk) then

            -- Debounce
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

            -- Rising edge
            if btn_stable = '1' and btn_prev = '0' then

                -- If stopped -> capture new word
                if reset_n = '1' then

                    captured_swv <= o_swv;

                    -- Pre-calculate LED states
                    acc := '0';

                    for k in 15 downto 0 loop

                        if o_swv(k) = '1' then
                            acc := not acc;
                        end if;

                        leds_state(k) <= acc;

                    end loop;

                end if;

                -- Toggle TX
                reset_n <= not reset_n;

            end if;

        end if;
    end process;

    -- =========================================================
    -- NRZI modulation
    -- =========================================================
    p_nrzi : process(clk)
    begin
        if rising_edge(clk) then

            if reset_n = '1' then

                bit_counter <= 0;
                bit_index   <= 15;

                aux_signal  <= '0';

                leds_out    <= (others => '0');

            else

                -- Apply NRZI transition only once per bit
                if bit_counter = 0 then

                    if captured_swv(bit_index) = '1' then
                        aux_signal <= not aux_signal;
                    end if;

                end if;

                leds_out <= leds_state;

                -- Timing
                if bit_counter = ciclos - 1 then

                    bit_counter <= 0;

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

    nrzi_out <= aux_signal;

end Behavioral;