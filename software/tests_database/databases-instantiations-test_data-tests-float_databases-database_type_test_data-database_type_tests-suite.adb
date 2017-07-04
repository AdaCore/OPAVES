--  This package has been generated automatically by GNATtest.
--  Do not edit any part of it, see GNATtest documentation for more details.

--  begin read only
with AUnit.Test_Caller;
with Gnattest_Generated;

package body Databases.Instantiations.Test_Data.Tests.Float_Databases.Database_Type_Test_Data.Database_Type_Tests.Suite is

   package Runner_1 is new AUnit.Test_Caller
     (GNATtest_Generated.GNATtest_Standard.Databases.Instantiations.Test_Data.Tests.Float_Databases.Database_Type_Test_Data.Database_Type_Tests.Test_Database_Type);

   Result : aliased AUnit.Test_Suites.Test_Suite;

   Case_1_1_Test_ID_c61842 : aliased Runner_1.Test_Case;
   Case_2_1_Test_Get_092341 : aliased Runner_1.Test_Case;
   Case_3_1_Test_Get_Timestamp_aa6da1 : aliased Runner_1.Test_Case;
   Case_4_1_Test_Set_8399ce : aliased Runner_1.Test_Case;
   Case_5_1_Test_Register_33e98f : aliased Runner_1.Test_Case;
   Case_6_1_Test_Get_Data_ID_7a2a32 : aliased Runner_1.Test_Case;
   Case_7_1_Test_Get_46e83a : aliased Runner_1.Test_Case;
   Case_8_1_Test_Set_89ccfc : aliased Runner_1.Test_Case;
   Case_9_1_Test_Log_All_Data_b000e7 : aliased Runner_1.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin

      Runner_1.Create
        (Case_1_1_Test_ID_c61842,
         "databases-generics.ads:44:4 instance at databases-instantiations.ads:43:4:",
         Test_ID_c61842'Access);
      Runner_1.Create
        (Case_2_1_Test_Get_092341,
         "databases-generics.ads:47:4 instance at databases-instantiations.ads:43:4:",
         Test_Get_092341'Access);
      Runner_1.Create
        (Case_3_1_Test_Get_Timestamp_aa6da1,
         "databases-generics.ads:52:4 instance at databases-instantiations.ads:43:4:",
         Test_Get_Timestamp_aa6da1'Access);
      Runner_1.Create
        (Case_4_1_Test_Set_8399ce,
         "databases-generics.ads:56:4 instance at databases-instantiations.ads:43:4:",
         Test_Set_8399ce'Access);
      Runner_1.Create
        (Case_5_1_Test_Register_33e98f,
         "databases-generics.ads:62:4 instance at databases-instantiations.ads:43:4:",
         Test_Register_33e98f'Access);
      Runner_1.Create
        (Case_6_1_Test_Get_Data_ID_7a2a32,
         "databases-generics.ads:66:4 instance at databases-instantiations.ads:43:4:",
         Test_Get_Data_ID_7a2a32'Access);
      Runner_1.Create
        (Case_7_1_Test_Get_46e83a,
         "databases-generics.ads:70:4 instance at databases-instantiations.ads:43:4:",
         Test_Get_46e83a'Access);
      Runner_1.Create
        (Case_8_1_Test_Set_89ccfc,
         "databases-generics.ads:74:4 instance at databases-instantiations.ads:43:4:",
         Test_Set_89ccfc'Access);
      Runner_1.Create
        (Case_9_1_Test_Log_All_Data_b000e7,
         "databases-generics.ads:79:4 instance at databases-instantiations.ads:43:4:",
         Test_Log_All_Data_b000e7'Access);

      Result.Add_Test (Case_1_1_Test_ID_c61842'Access);
      Result.Add_Test (Case_2_1_Test_Get_092341'Access);
      Result.Add_Test (Case_3_1_Test_Get_Timestamp_aa6da1'Access);
      Result.Add_Test (Case_4_1_Test_Set_8399ce'Access);
      Result.Add_Test (Case_5_1_Test_Register_33e98f'Access);
      Result.Add_Test (Case_6_1_Test_Get_Data_ID_7a2a32'Access);
      Result.Add_Test (Case_7_1_Test_Get_46e83a'Access);
      Result.Add_Test (Case_8_1_Test_Set_89ccfc'Access);
      Result.Add_Test (Case_9_1_Test_Log_All_Data_b000e7'Access);

      return Result'Access;

   end Suite;

end Databases.Instantiations.Test_Data.Tests.Float_Databases.Database_Type_Test_Data.Database_Type_Tests.Suite;
--  end read only
