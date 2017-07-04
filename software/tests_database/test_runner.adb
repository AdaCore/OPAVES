--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Reporter.gnattest;
with AUnit.Run;
with AUnit.Options; use AUnit.Options;
with Gnattest_Main_Suite; use Gnattest_Main_Suite;

procedure Test_Runner is
   procedure Runner is new AUnit.Run.Test_Runner (Suite);
   Reporter : AUnit.Reporter.gnattest.gnattest_Reporter;
   GT_Options : AUnit_Options := Default_Options;
begin

   GT_Options.Report_Successes := True;

   Runner (Reporter, GT_Options);
end Test_Runner;
--  end read only
