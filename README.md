# JSON Matcher

Let you get Difference in two json

It checks if the two jsons are similar or not. By similar we can say it sorts the internal arrays and hash to do the same.
It gives the difference in diff format with colors

# Usage

JsonMatcher.similar a, b

It returns nil if similar and a diff if different

Check Spec section for details

# Options

The only option currently supported is exact
eg JsonMatcher.similar a, b, {:exact => true}
This makes the match exact

