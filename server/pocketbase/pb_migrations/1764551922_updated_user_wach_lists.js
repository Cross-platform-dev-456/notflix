/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2697805646")

  // update collection data
  unmarshal({
    "name": "user_watch_lists"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2697805646")

  // update collection data
  unmarshal({
    "name": "user_wach_lists"
  }, collection)

  return app.save(collection)
})
