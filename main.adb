--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
with
  Neo.Foundation.Text_IO,
  Neo.Foundation.Data_Types,
  Neo.Foundation.Build_Options,
  Neo.Foundation.Package_Testing,
  Neo.Foundation.Generic_Protected,
  Neo.System,
  Neo.System.Memory,
  Neo.System.Processor;
procedure Main
  is
  begin
    --Neo.Foundation.Text_IO.Test;
    --Neo.Foundation.Package_Testing.Test;
    Neo.System.Test;
    Neo.System.Memory.Test;
    Neo.System.Processor.Initialize;
    Neo.System.Processor.Test;
  end Main;
