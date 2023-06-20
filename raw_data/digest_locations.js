const fs = require('fs');
const path = require('path');

try {
  const data = fs.readFileSync('locations.json');
  const jsonData = JSON.parse(data);

  processLocations(jsonData)

} catch (error) {
  console.error('Error reading JSON file:', error);
}



function processLocations(locations){
    // dois índices que a gente vai usar.
    const outputLocations  = new Map()
    const outputDimensions = new Map()

    const locationsArray = locations.data.locations.results
    for(let location of locationsArray){
        let locationPopuparity = location.residents.reduce( (previous,current) =>{
            return previous + current.episode.length
        },0)

        let processedLocation = {
            id        : parseInt(location.id),
            name      : location.name,
            type      : location.type,
            dimension : location.dimension,
            popularity: locationPopuparity
        }

        outputLocations.set( location.id, processedLocation)

    }

    const jsonData = JSON.stringify( [...outputLocations.values()],1," " )

    fs.writeFile( path.join(__dirname,'../src/data/locations.json'), jsonData, error =>{
        console.log(error ?? "OK")
    })

}