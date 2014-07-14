import json

def store(self,fl="env.json"):
    json.dump(self,open(fl,"w"))

def restore(name, fl="env.json"):
    return json.load(open(fl,"r"))[name]

    
