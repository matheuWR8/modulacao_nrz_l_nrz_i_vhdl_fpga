library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================
--  NRZI_Source
--  - Reads 16-bit switch vector on button press
--  - Mirrors NRZI accumulated states on LEDs
--  - Drives VGA 1920x1080 @60 Hz:
--      WHITE screen when nrzi_out = '1'
--      BLACK screen when nrzi_out = '0'
--
--  NRZ-I rule:
--      bit '1' -> invert output
--      bit '0' -> keep output
--
--  Clock Wizard:
--      100 MHz in → 148.5 MHz out
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

        nrzi_out : out STD_LOGIC;

        -- VGA
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC;

        vgaRed   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue  : out STD_LOGIC_VECTOR(3 downto 0)
    );

end NRZI_Source;

architecture Behavioral of NRZI_Source is

    -- =========================================================
    -- Clock Wizard
    -- =========================================================
    component clk_wiz_0
        port (
            clk_out1 : out STD_LOGIC;
            reset    : in  STD_LOGIC;
            locked   : out STD_LOGIC;
            clk_in1  : in  STD_LOGIC
        );
    end component;

    -- =========================================================
    -- VGA 1920x1080 @60Hz
    -- =========================================================
    constant H_VISIBLE : integer := 1920;
    constant H_FRONT   : integer := 88;
    constant H_SYNC    : integer := 44;
    constant H_BACK    : integer := 148;
    constant H_TOTAL   : integer := 2200;

    constant V_VISIBLE : integer := 1080;
    constant V_FRONT   : integer := 4;
    constant V_SYNC    : integer := 5;
    constant V_BACK    : integer := 36;
    constant V_TOTAL   : integer := 1125;

    signal clk148      : STD_LOGIC := '0';
    signal wiz_locked  : STD_LOGIC;

    signal h_count     : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count     : integer range 0 to V_TOTAL - 1 := 0;

    signal video_on    : STD_LOGIC := '0';

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
    -- Clock Wizard
    -- =========================================================
    u_clk_wiz : clk_wiz_0
        port map (
            clk_in1  => clk,
            clk_out1 => clk148,
            reset    => '0',
            locked   => wiz_locked
        );

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

    -- =========================================================
    -- VGA timing
    -- =========================================================
    p_vga_timing : process(clk148)
    begin
        if rising_edge(clk148) then

            if h_count = H_TOTAL - 1 then

                h_count <= 0;

                if v_count = V_TOTAL - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;

            else
                h_count <= h_count + 1;
            end if;

        end if;
    end process;

    -- =========================================================
    -- Sync signals
    -- =========================================================
    hsync <= '0' when (
                h_count >= H_VISIBLE + H_FRONT and
                h_count <  H_VISIBLE + H_FRONT + H_SYNC
             )
             else '1';

    vsync <= '0' when (
                v_count >= V_VISIBLE + V_FRONT and
                v_count <  V_VISIBLE + V_FRONT + V_SYNC
             )
             else '1';

    -- =========================================================
    -- Active video
    -- =========================================================
    video_on <= '1'
                when (
                    h_count < H_VISIBLE and
                    v_count < V_VISIBLE
                )
                else '0';

    -- =========================================================
    -- VGA colors
    --
    -- WHITE when NRZI = 1
    -- BLACK when NRZI = 0
    -- =========================================================
    vgaRed <= "1111"
              when (
                  video_on = '1' and
                  aux_signal = '1'
              )
              else "0000";

    vgaGreen <= "1111"
                when (
                    video_on = '1' and
                    aux_signal = '1'
                )
                else "1100";

    vgaBlue <= "1111"
               when (
                   video_on = '1' and
                   aux_signal = '1'
               )
               else "0000";

end Behavioral;