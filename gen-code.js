#!/usr/bin/env node
var beautify = require('js-beautify').js_beautify;

var util = require('util');
var fs = require('fs');
var PEG = require("./grammar.js");
var fileName = process.argv[2] || 'input1';

let prefixTemplate = function() {
  return `
module.exports = () => {
  let e;
  let sym = {};
  try {
  `; 
}; // end prefix

let suffixTemplate  = function() {
   return `
     return sym;
  }
  catch(e) {
    let err = e.message.replace(/sym\\.(\\w+)/g, '$1');
    console.log(err);
    return "error";
  }
}
`; 
}; // end suffix

var translate = function(treeNode) {
    var nodeTranslation = "";
    if(treeNode)
    switch(treeNode.type) {
        case "PROGRAMA":
            return nodeTranslation + translate(treeNode.value);
            
        case "BLOQUE":
            treeNode.value.forEach( function(instruccion) {
                nodeTranslation += translate(instruccion);
            })
            return nodeTranslation;
            
        case "CONSTANTES":
            nodeTranslation += treeNode.constantes.map( function (node) {
                return "sym['" + node.id + "'] = " + node.value + ";";
            }).join("\n");
            return nodeTranslation;
            
        case "VARIABLES":
            nodeTranslation += treeNode.variables.map( function (node) {
                return "sym['" + node.id + "'] = null;";
            }).join("\n");
            
            return nodeTranslation;
            
        case "PROCEDURE":
            nodeTranslation += "var " + treeNode.id + " = function(" ;
            nodeTranslation += treeNode.argumentos.map( function(node) {
                return node['arg']['value'];
            }).join(", ");
            nodeTranslation += ") {\n" + translate(treeNode.bloq) + ")};\n";
            return nodeTranslation;
            
        case "ASIGNACION":
            return "sym['" + treeNode.id + "'] = " + translate(treeNode.exp) +";\n";
            
        case "EXPRESION":
            if(treeNode.value) {
                return translate(treeNode.value);
            } else {
                return "" + translate(treeNode.leftT) + treeNode.op + translate(treeNode.rightT);
            }
            
        case 'INSTRUCCION':
            return translate(treeNode.instruccion);
            
        case 'RETURN':
            return "return " + translate(treeNode["value"]) + ";\n";
            
        case 'BEGIN-END':
            treeNode.instrucciones.forEach( function(node) {
                nodeTranslation += translate(node['instruc']);
            });
            return nodeTranslation;
            
        case 'CALL':
            nodeTranslation += treeNode.id + "(";
            nodeTranslation += treeNode.argumentos.map( function(node) {
                return translate(node.arg);
            }).join(', ');
            nodeTranslation += ");\n"
            return nodeTranslation;
            
        case 'ARGUMENTOID':
            return "sym['" + treeNode["value"] + "']";
            
        case 'ARGUMENTO':
            return translate(treeNode['value']);
            
        case 'TERM':
            if(treeNode.value) {
                return translate(treeNode.value);
            } else {
                return "" + translate(treeNode.leftT) + treeNode.op + translate(treeNode.rightT);
            }
            
        case 'FACTOR':
            return treeNode["value"];
            
        case 'FACTORNUM':
            return treeNode["value"];
            
        case 'FACTORID':
            return "sym['" + treeNode["value"] + "']";
            
        case 'IF':
            nodeTranslation += "if (" + translate(treeNode.condicion) + ") {\n" + translate(treeNode.instruccion) + "}";
            if(treeNode.instruccionelse) {
                nodeTranslation += " else {\n" + translate(treeNode.instruccionelse) + "}\n";
            }
            return nodeTranslation;
            
        case 'WHILE':    
            return "while (" + translate(treeNode.condicion) + ") {\n" + treeNode.instrucciones.map( function(instruccion) { return translate(instruccion) }) + "};\n";

        case 'CONDICION':
            return "" + translate(treeNode.leftT) + treeNode.op + translate(treeNode.rightT);
            
        case 'CONDICION ODD':
            return translate(treeNode.value) +"%2 == 1";
            
        default:
            return treeNode;
    }
}

/*module.exports = function(tree) {

   var prefix = prefixTemplate();
   var suffix = suffixTemplate();
   let js = prefix+translate(tree)+suffix;
   return beautify(js, { indent_size: 2 });
};*/

fs.readFile(fileName, 'utf8', function (err,input) {
  if (err) {
    return console.log(err);
  }
  console.log(`Processing <\n${input}\n>`);
  var r = PEG.parse(input);
   let js = translate(r);
   
  console.log(beautify(prefixTemplate() + js + suffixTemplate(), {indent_size:2}));
  return (beautify(prefixTemplate() + js + suffixTemplate(), {indent_size:2}));
  //console.log(util.inspect(r, {depth: null}));
});