Config = {}

Config.ped={
    vector4(455.69, -1026.63, 27.48, 5.65),
    vector4(449.44, -1026.03, 27.59, 358.77)
}

Config.policegarege = 
{   [1]={
    
    jobs="police",
    carspawn = vector4(443.9, -1020.57, 28.57, 101.4),
    cartype = {
    {label="Mustang", car="npolstang", grade={1,2}},
    {label="Charger", car="npolchar",grade={1,2}},
    {label="Explorer", car="npolexp",grade={1,15}},
    {label="Victoria", car="npolvic",grade={1,15}}
    },
    },

    [2]={
       
    jobs="ambulance",
    carspawn = vector4(426.35, -1024.34, 28.96, 131.22),
    cartype = {
    {label="Ambulance", car="ambulance",grade={1,2}},

    },
    },
    
  }
  