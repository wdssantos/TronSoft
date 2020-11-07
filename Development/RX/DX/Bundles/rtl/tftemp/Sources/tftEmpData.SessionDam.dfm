inherited damSession: TdamSession
  OldCreateOrder = True
  Height = 89
  Width = 226
  object Connection: TFDConnection
    Params.Strings = (
      'Database=C:\Tronsoft\TRONSOFT.GDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Left = 40
    Top = 24
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    VendorLib = 'C:\Tronsoft\fbclient.dll'
    Left = 136
    Top = 24
  end
end
