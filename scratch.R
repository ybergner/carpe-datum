# prob die between now and 80 = prob(die at 21) + prob(die at 22|lived to 22)
#
1* lifetableNCHS[21, "qx"] +
(1-lifetableNCHS[21, "qx"])*lifetableNCHS[22, "qx"] +
(1-lifetableNCHS[21, "qx"])*lifetableNCHS[22, "qx"]


vec1 <- c(1, 1 - lifetableNCHS[21:80,"qx"])
vec2 <- c(lifetableNCHS[21:81,"qx"])
vec1 %*% vec2
1- vec1 %*% vec2


vec1 <- c(1, 1 - lifetableNCHS[61:80,"qx"])
vec2 <- c(lifetableNCHS[61:81,"qx"])
sum(vec1 * vec2)
vec1 %*% vec2
1- vec1 %*% vec2

prod(1-lifetableNCHS[21:80,"qx"])
sum(lifetableNCHS[81:101,"dx"])/sum(lifetableNCHS[21:101,"dx"])


sum(lifetableNCHS[81:101,"dx"])/sum(lifetableNCHS[22:101,"dx"])

prod(1-lifetableNCHS[61:80,"qx"])
sum(lifetableNCHS[81:101,"dx"])/sum(lifetableNCHS[61:101,"dx"])

workingsum <- 0
for (n in 21:80) {
  if (n == 21) {
    probstillalive <- 1
  } else {
    probstillalive <- prod(1-lifetableNCHS[21:n,"qx"])
  }
  probDieThisYear <- lifetableNCHS[n,"qx"]
  workingsum <- workingsum + probstillalive*probDieThisYear
}
1- workingsum

1-sum(lifetableNCHS[22:80,"lx"]/100000 * lifetableNCHS[22:80,"qx"])


t(lifetableNCHS[61:70,"lx"]/100000) %*% lifetableNCHS[61:70,"qx"]


postal_df <- data.frame(stringsAsFactors=FALSE,
                        State = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                                  "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
                                  "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas",
                                  "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
                                  "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana",
                                  "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
                                  "New York", "North Carolina", "North Dakota", "Ohio",
                                  "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
                                  "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
                                  "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"),
                        PostalCode = c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                                       "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                                       "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                                       "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD",
                                       "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")
)

# created a named vector
getpostalcode <- postal_df$PostalCode
names(getpostalcode) <- postal_df$State
