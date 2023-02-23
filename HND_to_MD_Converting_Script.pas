
type
  TStringArray = array of string;
var
  // Current topic ID
  aTopicId: string;
var
  //The Output list where all the topics will be written
  aList: TStringList;

  var lvl: integer;
  var s: string;
  var ss, str: String;
  var folderName: String;             
  

// Get the levels of the topics and subtopics 
procedure getLvl(lv: Integer);
  var j: Integer;
  begin
    s:="##";
    if (lv = 3) then 
    begin
       s:="";
       Exit
    end;    
    for j:=1 to lv do
        s:= s + "#";
  end;


// Recursive procedure for getting a list of all the topics and all their subtopics, at any level
 procedure FillArray(aTopicId: String);
  var
    List: THndTopicsInfoArray;
    IDArray: TStringArray;
    J: Integer;
    
  begin      
    List := HndTopics.GetTopicDirectChildrenList(aTopicId);
    if Length(List) = 0 then
       Exit;
    IDArray.SetLength(Length(List));
    for J := 0 to Length(List) - 1 do
      begin
        IDArray[J] := List[J].Id;       
      end;

    for J := 0 to Length(IDArray) - 1 do
      begin
        getLvl(HndTopics.GetTopicLevel(IDArray[J]));

        aList.Add(" ");    
        if (s = "") then
           begin
               aList.Add("!!! warning """"");
               aList.Add(" ");
               aList.Add("    " + HndTopics.GetTopicCaption(IDArray[J]));
           end
        else
           begin
               aList.Add(s + " " + HndTopics.GetTopicCaption(IDArray[J]) + " " + s);
           end;     
             
        aList.Add(" ");
        aList.Add(" ");            
        FillArray(IDArray[J]); 
      end;     
  end;  



// Main program
begin
var
  aTopicList: TStringArray;
var
  sTopicId: String;
var
  nCnt: Integer;
  sTopicId := HndTopics.GetTopicFirst;
  aTopicList.SetLength(0);

  While (sTopicId <> '') do  
	  begin
	    aTopicList.SetLength(Length(aTopicList) + 1);
	    aTopicList[Length(aTopicList) - 1] := sTopicId;
	    sTopicId := HndTopics.GetTopicNextSibbling(sTopicId);
	  end;

  aList := TStringList.Create;
  aList.Add("## " + HndProjects.GetProjectTitle() + " ##");
  aList.Add(" ");  
  
  for nCnt := 0 to Length(aTopicList) - 1 do
  begin
   getLvl(HndTopics.GetTopicLevel(aTopicList[nCnt]));
   aList.Add(s + " " + HndTopics.GetTopicCaption(aTopicList[nCnt]) + " " + s);
   aList.Add(" ");

   if (HndTopics.GetTopicCaption(aTopicList[nCnt]) = "Photos") then
   begin
       aList.Add("![](sharper.jpg)");
       aList.Add(" "); 
   end; 
 

   if (HndTopics.GetTopicDescription(aTopicList[nCnt]) <> "") then 
      begin
           aList.Add("!!! abstract """"");
           aList.Add(" ");
           aList.Add("    " + HndTopics.GetTopicDescription(aTopicList[nCnt]));
      end; 

   aList.Add(" ");   
   FillArray(aTopicList[nCnt]);   
  end; 
 
  // Save the list with all the topics in a text file named like <Movie-name>.md 
  aList.SaveToFile(LeftStr(HndProjects.GetProjectName(), HndProjects.GetProjectName().Length -4)  + ".md");
   
  aList.Free;
      
end.