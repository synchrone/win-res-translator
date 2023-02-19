{
    var word_Obj = {};
    var word_alnum_Obj = {};
    var word_alnumsp_Obj = {};
    var dir_Obj = {};
    var valStateDec_Obj = {};
    var stateName_Obj = {};
    var valStateVal_Obj = {};
    var word_Count = 0;
    var word_alnum_Count = 0;
    var word_alnumsp_Count = 0;
    var dir_Count = -1;
    var valStateDec_Count = 0;
    var stateName_Count = -1;
    var valStateVal_Count = -1;
    var begin_Count = -1;
    var end_Count = -1;
    var child_Count = -1;
    var children_Count = -1;
    var flag = 0;
}

Expected = dir:directive * nl * states:state nl* Ending:EOL
{if (begin_Count === end_Count) {
return { Parsed_RC: {
Directive_Obj: dir, States_Obj: states, ENDING: Ending
}
}
} else { return "Incorrect .RC file" }
}
directive = "#" d: word space* v:word_alnumsp nl+ {
dir_Count++;
dir_Obj = {
['Directive_' + dir_Count]:
{ "Dir": d, "_text": v } };
return dir_Obj;
}
state = (valState looping)*
looping = (loopStart loopEnd*)*
loopStart = beg child: valState + {
begin_Count++; children_Count++; child_Count++;
return {['loopStart_' + begin_Count]: begin_Count,
['child_' + children_Count]: child } }

loopEnd = end {end_Count++; child_Count--;
return { ['loopEnd_' + end_Count]: end_Count }; }
valState = stateName(valStateVal) * nl +
    //valStateDec = space+ decState_val:word_alnumsp {valStateDec_Count++; valStateDec_Obj = {['ValStateDec_Obj'+valStateDec_Count]:decState_val}; return valStateDec_Obj;}
stateName = space * state_name:word_alnumsp {

if (state_name === 'BEGIN') {
begin_Count++;
children_Count++;
child_Count++;
return { ['loopStart_' + begin_Count]: begin_Count }
}

if (state_name === 'END') {
end_Count++;
child_Count--;
return { ['loopEnd_' + end_Count]: end_Count }; }
if (child_Count < 0) { flag = 1; }
stateName_Count++;
stateName_Obj = { ['StateName_Obj' + stateName_Count]: state_name };
return stateName_Obj;
}

valStateVal = space + valState_val:(word_alnumsp comma?)* {
valStateVal_Count++;
valStateVal_Obj = {
['_attributes_Obj' + valStateVal_Count]: valState_val };
return valStateVal_Obj
}
word = wo:letter + { return wo.join("") }
word_alnum = al:alnum + { return al.join("") }
word_alnumsp = alsp:alnumsp + { return alsp.join("") }

beg = space * ([{]) space* nl +
    end = space * ([}]) space* nl +
        comma = space * [,] space* { return ","}

letter = [a-zA-Z]
alnum = [a-zA-Z0-9]
alnumsp = [a-zA-Z-0-9"'&._()\\|+:]
    space = " "
    nl = '\n' {valStateVal_Count = -1; return "NL"}
    EOL = !. {return "EOF"}