import fs from 'fs'
import fetch from 'node-fetch'
import replaceAsync from "string-replace-async";

const DEEPL_API_KEY = process.env.DEEPL_API_KEY
const LANG = process.env.LANG || 'RU'

let rcfile = fs.readFileSync(process.argv[2], {encoding: 'utf16le'});


let menupopupcontrolRegexp = /(MENUITEM "|POPUP "|CONTROL ")([^_"](\\"|[^"])*)(")/g;

async function translate(text, lang, srcLang){
  if(!DEEPL_API_KEY){
    return `<UNTRANSLATED: ${text}>`
  }
  const formData = new URLSearchParams();
  formData.append('text', text)
  if(srcLang) {
    formData.append('source_lang', srcLang)
  }
  formData.append('target_lang', lang)
  // formData.append('tag_handling', 'xml')

  const response = await fetch('https://api-free.deepl.com/v2/translate', {
    headers: {
      'Authorization': `DeepL-Auth-Key ${DEEPL_API_KEY}`
    },
    method: 'POST',
    body: formData
  })
  const resJson = await response.json()
  const translation = resJson.translations[0].text

  return translation
}

async function translator(m, preceding, text, grp3, following, fileOffset) {
  if(text.trim().length > 0) {
    text = text.replace("\\n", "\n")
    text = await translate(text.replace('&', ''), LANG)
    text = text.replace("\n", "\\n")
    text = text.replace(/([^\\])"/g, '$1\\"') // deepl can add quotes
  }

  return `${preceding}${text}${following}`
}

rcfile = await replaceAsync(rcfile, menupopupcontrolRegexp, translator)

const stringtableRegexp = /^(\s+\d+,\s+\")((\\"|[^"])*)(")/gm;
rcfile = await replaceAsync(rcfile, stringtableRegexp, translator);

process.stdout.write(Buffer.from(rcfile,'utf16le'));
