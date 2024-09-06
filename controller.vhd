library IEEE; 
use IEEE.STD_LOGIC_1164.all;

---------------- Unidade de Controle ----------------------
-                                                         -
- Esse módulo implementa a unidade de controle, compondo  -
- os módulos maindec e aludec.                            -
-                                                         -
- Entradas:                                               -
-   op (6 bits): opcode da instrução.                     - 
-   funct (6 bits): campo funct (instruções tipo-R).      -
-   zero (1 bits): bit zero da saída da ula.              -
- Saidas:                                                 -
-   memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite,  -
-   jump e alucontrol são sinais que controlam o datapath.-
-                                                         -
- Para mais detalhes, ver figura 7.59 e seção 7.3.2, 7.3.3-
- do livro indicado, bem com as figuras 7.12 e 7.14 e     -
- tabelas 7.1, 7.2 e 7.3.                                 -
-----------------------------------------------------------

-- É seu trabalho interligar os submódulos da unidade de 
-- controle: maindec e aludec, bem como implementar a 
-- lógica do sinal pcsrc, que é usado como sinal de seleção
-- do primeiro mix na entrada do pc (ver figura 7.14).


entity controller is 
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
end;


architecture struct of controller is
  component maindec
    port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch, alusrc:     out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out STD_LOGIC_VECTOR(1 downto 0));
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  
  signal aluop:  STD_LOGIC_VECTOR(1 downto 0);
  signal branch: STD_LOGIC;
begin
  -- Faça: Instancie o main decoder (maindec) passando op (opcode) e os 9 sinais de saida.
  -- Referência:  figura 7.11 e 7.12 do livro.
  maindec_inst: maindec port map(
    op        => op,               -- Conecta o opcode à entrada de 'maindec'
    memtoreg  => memtoreg,         -- Conecta a saída 'memtoreg' de 'maindec' à saída de 'controller'
    memwrite  => memwrite,         -- Conecta a saída 'memwrite' de 'maindec' à saída de 'controller'
    branch    => branch,           -- Conecta a saída 'branch' de 'maindec' ao sinal intermediário 'branch'
    alusrc    => alusrc,           -- Conecta a saída 'alusrc' de 'maindec' à saída de 'controller'
    regdst    => regdst,           -- Conecta a saída 'regdst' de 'maindec' à saída de 'controller'
    regwrite  => regwrite,         -- Conecta a saída 'regwrite' de 'maindec' à saída de 'controller'
    jump      => jump,              -- Conecta a saída 'jump' de 'maindec' à saída de 'controller'
    aluop     => aluop             -- Conecta a saída 'aluop' de 'maindec' ao sinal intermediário 'aluop'
  );
  
  --Faça: instancie o alu decoder (aludec) a saida desse modulo deve ser direcionada
  -- para o sinal de saida alucontrol, que controlara a ula (veja figuras 7.11 e 7.12)
  aludec_inst: aludec port map(
    funct      => funct,           -- Conecta o campo de função à entrada de 'aludec'
    aluop      => ulaop,           -- Conecta o sinal 'ulaop' de 'maindec' à entrada de 'aludec'
    alucontrol => alucontrol       -- Conecta a saída 'alucontrol' de 'aludec' à saída de 'controller'
  );

  -- Faça: Elabore a lógica do pcsrc usando uma porta and.
  -- Esse bit será o seletor do primeiro mux2 na entrada do PC (veja figura 7.14)
  pcsrc <= op(5) and zero;

end struct;
