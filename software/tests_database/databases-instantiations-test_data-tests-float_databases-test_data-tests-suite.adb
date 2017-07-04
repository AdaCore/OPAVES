--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Caller;
with Gnattest_Generated;

package body Databases.Instantiations.Test_Data.Tests.Float_Databases.Test_Data.Tests.Suite is

   package Runner_1 is new AUnit.Test_Caller
     (GNATtest_Generated.GNATtest_Standard.Databases.Instantiations.Test_Data.Tests.Float_Databases.Test_Data.Tests.Test);

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Case_1_1_Test_Get_Database_Instance_e71beb : aliased Runner_1.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Runner_1.Create
        (Case_1_1_Test_Get_Database_Instance_e71beb,
         "databases-generics.ads:40:4 instance at databases-instantiations.ads:43:4:",
         Test_Get_Database_Instance_e71beb'Access);

      Result.Add_Test (Case_1_1_Test_Get_Database_Instance_e71beb'Access);

      return Result'Access;

   end Suite;

end Databases.Instantiations.Test_Data.Tests.Float_Databases.Test_Data.Tests.Suite;
--  end read only
