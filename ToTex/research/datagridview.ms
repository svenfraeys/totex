(
 local iEntryIndex = 0
 txtclmn = dotNetObject "System.Windows.Forms.DataGridViewTextBoxColumn"
 cbclmn = dotNetObject "System.Windows.Forms.DataGridViewCheckBoxColumn" 

fn fnInitDotNetView dncFileView =
(
 dncFileView.AllowUserToAddRows = off
 dncFileView.AutoSize = on
 dncFileView.AutoSizeColumnsMode = dncFileView.AutoSizeColumnsMode.Fill
 dncFileView.ColumnHeadersDefaultCellStyle.Alignment = dncFileView.ColumnHeadersDefaultCellStyle.Alignment.MiddleCenter 
 dncFileView.ShowEditingIcon = dncFileView.RowHeadersVisible = off 
 txt1 = txtclmn.clone()
 txt1.HeaderText = "Object Name"
 dncFileView.columns.add (txt1)
 cb1 =cbclmn.clone()
 cb1.HeaderText = "H"
 dncFileView.columns.add (cb1)
 cb2 =cbclmn.clone()
 cb2.HeaderText = "R"
 dncFileView.columns.add (cb2)
 txt2 = txtclmn.clone()
 txt2.HeaderText = "Notes"
 dncFileView.columns.add (txt2)
 dncFileView.RowCount = 2
)
 
try(destroyDialog roDotNetTestDialog)catch()

rollout roDotNetTestDialog "DotNet Test Dialog" 
(
 dotNetControl  dncFileView "DataGridView" pos:[10,10] width:380 height:180
 edittext  etInputText  "Input" pos:[10,200] width:380
 button btnAddText  "Add" pos:[175,225] width:50 align:#center

 on roDotNetTestDialog open do 
 (
 fnInitDotNetView roDotNetTestDialog.dncFileView
 )
)

createDialog roDotNetTestDialog 400 260
)