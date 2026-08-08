
  A few ways to get  claude -p  output to render well through  glow :         
                                                                              
  Shape the output itself (most impactful)                                    
                                                                              
  • Add a short instruction in your prompt or a system prompt ( --append-     
  system-prompt ) telling Claude to structure responses with markdown:  ##    
  headers per section,  ---  horizontal rules between major sections, bullet  
  lists instead of dense paragraphs, and fenced code blocks. Glow renders all 
  of these distinctly (headers get color/weight,  ---  becomes a visible      
  divider).                                                                   
  • Explicitly ask for tables when the output is structured/comparative — glow
  renders markdown tables cleanly and they're much easier to scan than prose. 
                                                                              
  glow flags worth using                                                      
                                                                              
  •  -s dark  /  -s light  /  -s auto  — pick a style that matches your       
  terminal theme.                                                             
  •  -w <n>  — set wrap width (e.g.  -w 100 ) so long lines don't get glow's  
  default narrow wrap.                                                        
  •  -p  — pager mode, useful if output is long (lets you scroll instead of   
  dumping to scrollback).                                                     
                                                                              
  Practical pipeline tweaks                                                   
                                                                              
  •  claude -p "..." --output-format text | glow -  (glow needs  -  to read   
  stdin explicitly in some versions — worth confirming with  glow --help ).   
  • If you want per-run separation in scrollback, echo a timestamp/divider    
  before the pipe:  echo "── $(date) ──"; claude -p "..." | glow - .          
  • If you're scripting repeated calls, wrap it in a shell function so you    
  don't retype the flags each time.                                           
                                                                              
  Given your CLAUDE.md preference for concise, no-fluff output, I'd keep the  
  system-prompt addition minimal — just "use markdown headers and bullet      
  points, avoid dense paragraphs" — rather than something elaborate, since    
  over-specifying formatting tends to fight with your existing terseness      
  preference.                                                                 
