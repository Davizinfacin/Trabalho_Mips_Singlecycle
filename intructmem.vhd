library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
  
------------ Memória de Instrução (instructmem) ------------
-                                                          -
- Entradas:                                                -
-   a (6 bits): endereço de leitura (vem do pc).           -
- Saídas:                                                  -
-   rd (32 bits): porta de leitura.                        -
-                                                          -
- Implementa uma memória com 64 palavras de 32 bits,       -
- com capacidade de leitura combinational (independente de -
- clock), inicializada com um programa. Para detalhes      -
- sobre o programa carregado, veja a figura 7.60 do livro  -
------------------------------------------------------------

-- Nao altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.


entity instructmem is 
  port(a:  in  STD_LOGIC_VECTOR(5 downto 0); 
       rd: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of instructmem is

   -- Array de memória inicializado com o programa	
   type ram_type is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
   signal mem: ram_type := (
	   0 => x"20020005",
           1 => x"2003000c",
           2 => x"2067fff7",
           3 => x"00e22025",
           4 => x"00642824",
           5 => x"00a42820",
           6 => x"10a7000a",
           7 => x"0064202a",
           8 => x"10800001",
           9 => x"20050000",
           10 => x"00e2202a",
           11 => x"00853820",
           12 => x"00e23822",
           13 => x"ac670044",
           14 => x"8c020050",
           15 => x"08000011",
           16 => x"20020001",
           17 => x"ac020054",
	   others => (others => '0')
	);

begin	 
	-- leitura combinacional (independente de clock)
	rd <= mem(to_integer(unsigned(a)));
end synth;

