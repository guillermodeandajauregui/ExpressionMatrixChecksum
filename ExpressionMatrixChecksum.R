
library(digest)
library(argparser)
library(data.table)

p = arg_parser("files")
p = add_argument(p, "input", help = "input file")
p = add_argument(p, "output", help = "output file")
argv = parse_args(p)

x = fread(input = argv$input)

y = apply(X = x, MARGIN = 2, digest, algo = "md5")
z = table(y)
w = names(z)[which(z>1)]

if(length(w)!=0){
  output = data.frame(hash = character(), 
                      samples = character(), 
                      stringsAsFactors = FALSE
                      )
  for(i in seq_along(w)){
  output[i,1] = w[i]
  muestras = names(which(y == w[i]))[order(names(which(y == w[i])))]
  output[i,2] = paste(muestras, collapse = " ")
  }

  fwrite(output, file = argv$output, sep = "\t")
  } else
  
file.create(argv$output)
print("no repeats!")



    

