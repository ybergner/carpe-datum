renameACSvars <- function(df) {
  acsVars <- read.csv("data/coronavirus-nyc/acs_vars.csv", stringsAsFactors = FALSE)
  getRealName <- acsVars$realName
  names(getRealName) <- acsVars$acsName

  acs_df_names <- which(names(df) %in% acsVars$acsName)
  names(df)[acs_df_names] <- getRealName[names(df)[acs_df_names]]
  names(df)
}
