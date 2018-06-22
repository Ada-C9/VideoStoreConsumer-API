- only one change to the API...it needs to add movies to the rental library (which is in its local database, not the external API) when the user clicks the "add to library" button on the search results page

- the search results page queries the external api after going through a route that is in our api wrapper...only some of the possible movies are currently in the rental library as the seeds file does not add everything

- the seeds file creates the rental library with the help of the external api, the title is the only item that is used from the movies.json file, the inventory is not involved anywhere...it is meaningless...we can assume there is endless inventory

- only functionality of the app is that you can search for a movie, view the rental library, select movie and customer which is info that's stored until a controlled form is submitted

- the controlled form sends a post request to our api wrapper which records the checkout though there is no get request for this so the information can't be viewed anywhere
