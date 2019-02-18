def paginated_response(count, data)
  {
    "meta"  => {"count" => count},
    "links" => a_hash_including(
      "first" => a_string_including("?offset=0"),
      "last"  => a_string_including("?offset=")
    ),
    "data"  => data
  }
end
