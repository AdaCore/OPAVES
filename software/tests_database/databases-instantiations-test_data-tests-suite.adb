--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Caller;
with Gnattest_Generated;

package body Databases.Instantiations.Test_Data.Tests.Suite is

   package Runner_1 is new AUnit.Test_Caller
     (GNATtest_Generated.GNATtest_Standard.Databases.Instantiations.Test_Data.Tests.Test);

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Case_1_1_Test_Set_Raw_Data_10fee9 : aliased Runner_1.Test_Case;
   Case_2_1_Test_Get_Raw_Data_2e7f87 : aliased Runner_1.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Runner_1.Create
        (Case_1_1_Test_Set_Raw_Data_10fee9,
         "databases-instantiations.ads:23:4:",
         Test_Set_Raw_Data_10fee9'Access);
      Runner_1.Create
        (Case_2_1_Test_Get_Raw_Data_2e7f87,
         "databases-instantiations.ads:29:4:",
         Test_Get_Raw_Data_2e7f87'Access);

      Result.Add_Test (Case_1_1_Test_Set_Raw_Data_10fee9'Access);
      Result.Add_Test (Case_2_1_Test_Get_Raw_Data_2e7f87'Access);

      return Result'Access;

   end Suite;

end Databases.Instantiations.Test_Data.Tests.Suite;
--  end read only
