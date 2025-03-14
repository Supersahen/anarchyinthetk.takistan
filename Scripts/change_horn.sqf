_horn = current_horn;

switch (_horn) do {

case "policehorn" : {current_horn = "policehorn2"; player groupChat "Changed horn to horn 2"};

case "policehorn2" : {current_horn = "policehorn3"; player groupChat "Changed horn to horn 3"};

case "policehorn3" : {current_horn = "policehorn"; player groupChat "Changed horn to default"};

};