
  ack_df <- tibble::tribble(
    
    ~iteration, ~Title, ~Name, ~Cont, ~Inst, ~Current, ~Notes
    
    # Iteration 1
    , "1", NA, "Nigel Willoughby", "Author", "DEW", 1, NA
    , "1", NA, "Joel Allan", "Author", "DEW", 1, NA
    , "1", NA, "Simeon Zylinski", "Author", "DEW", 1, NA
    , "1", "Dr", "Stuart Brown", "Author", "DEW", 0, NA
    
    , "1", NA, "Andrew West", "Principal", "DEW", 1, NA
    
    , "1", "Dr", "Matt White"
    , "Reviewer", "Arthur Rylah Institute for Environmental Research", 1
    , "reviewed an earlier version of this report and provided valuable suggestions and comments that improved the quality, clarity and interpretation of this report"
    
    , "1", "Dr", "Stuart Brown"
    , "Reviewer", NA, 1
    , "reviewed an earlier version of the code that creates the species distribution models"
    
    , "1", NA, "Rob Brandle"
    , "Other", "DEW", 1
    , "provided expert input to early versions of certain species distribution models and provided numerous extra records of flora and fauna"
    
    , "1", NA, "Dan Duval"
    , "Other", "South Australian Seed Conservation Centre", 1
    , "provided expert input to early versions of certain species distribution models and provided numerous extra records of flora"
    
  )
  