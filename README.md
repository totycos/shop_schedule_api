# API Documentation

This API provides : 

- endpoints,
- validations, 
- request and response exemples,
- error handling informations,
- testing informations,
- and deployement informations,

for managing shops and their schedules.



## Endpoints

### Shops

- `GET /api/v1/shops`: Returns a list of all shops with their schedules sorted starting from today's day.
  Exemple if today is Friday, the order will be  (in french) : Vendredi, Samedi, Dimanche, Lundi, Mardi, Mercredi, Jeudi. 
- `GET /api/v1/shops/:id`: Returns the shop with the given ID along with its schedules.
- `POST /api/v1/shops`: Creates a new shop. The request body should include the shop details.
- `PATCH /api/v1/shops/:id`: Updates the shop with the given ID. The request body should include the updated shop details.
- `DELETE /api/v1/shops/:id`: Deletes the shop with the given ID.

### Schedules

- `GET /api/v1/shops/:shop_id/schedules`: Returns a list of all schedules for the shop with the given ID, sorted starting from today's day.
- `GET /api/v1/shops/:shop_id/schedules/:id`: Returns the schedule with the given ID for the shop with the given ID.
- `POST /api/v1/shops/:shop_id/schedules`: Creates a new schedule for the shop with the given ID. The request body should include the schedule details.
- `PATCH /api/v1/shops/:shop_id/schedules/:id`: Updates the schedule with the given ID for the shop with the given ID. The request body should include the updated schedule details.
- `DELETE /api/v1/shops/:shop_id/schedules/:id`: Deletes the schedule with the given ID for the shop with the given ID.



## Validations

### Schedule

- day: Must be one of the following values: "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday". This field is required.  

- opening_time et closing_time : Must be a valid time string in the format "HH:MM". These fields are required. 

- shop_id: Must be the ID of an existing shop. This field is required.

- An opening_time has to be before the closing_time in an instance.  

- The opening_time and closing time of a new instance can't overlap the opening_time and closing_time of another instance with the same day and shop_id.

### Shop

- name: This field is required and must be unique (case insensitive).



## Request and Response Examples

### POST /api/v1/shops

Request body:
```json 
{  
  "api_v1_shop": {
    "name": "ShopName"
  }
}
```

Response body:
```json 
{  
  "id": 1,
  "name": "ShopName",
  "sorted_schedules": []
}
```


### PATCH /api/v1/shops/:id

Request body:
```json 
{  
  "api_v1_shop": {
    "name": "UpdatedShopName"
  }
}
```

Response body:
```json
{  
  "id": 1,
  "name": "UpdatedShopName",
  "sorted_schedules": []
}
```

#### POST /api/v1/shops/:shop_id/schedules

Request body:
```json
{
  "api_v1_shop_schedule": {
    "day": "Wednesday",
    "opening_time": "14:30",
    "closing_time": "16:00"
  }
}
```

Response body:
```json
{
   "day": "Wednesday",
    "opening_time": "2000-01-01T14:30:00.000Z",
    "closing_time": "2000-01-01T16:00:00.000Z"
}
```

#### PATCH /api/v1/shops/:shop_id/schedules/:id

Request body:
```json
{
  "api_v1_shop_schedule": {
    "day": "Wednesday",
    "opening_time": "14:30",
    "closing_time": "16:00"
  }
}
```

Response body:
```json
{
  "day": "Wednesday",
  "opening_time": "2000-01-01T14:30:00.000Z",
    "closing_time": "2000-01-01T16:00:00.000Z"
}
```



## Error Handling

If a request is invalid, the API will return a response with a status code of 400 or higher. The response will include an error message explaining what went wrong. For example, if you try to create a shop without a name, you might get a response like this:

```json
{
  "name": [
    "can't be blank"
  ]
}
```

- If you try to update or delete a shop that doesn't exist:
```json
{
  "error": "Shop not found"
}
```



## Testing

The API includes a suite of tests written with RSpec. The tests cover various scenarios including successful requests, invalid requests, and error handling. The types of tests include:  
  
- Unit tests: These tests cover individual methods and functions in the models and controllers.  
- Integration tests: These tests cover the interaction between different parts of the application, such as making a request to an endpoint and checking the response.  
  
You can run the tests with the `bundle exec rspec` command. The tests are located in the spec directory.  



## Get started

This API is designed to be used with Ruby and Rails installed. Here are some recommendations for the environment:  
  
- Ruby version: The latest stable version is recommended.  
- Rails version: The version used in this project or newer.  
- Database: SQLite is recommended.  

1. Clone the repository to your machine. Navigate to the project directory. Run `bundle install` to install gem dependencies.

2. Set up your database with the `rails db:setup` command. This will create the database, load the schema, and initialize it with the seed data.  




