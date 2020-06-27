-- HTTP POST script which simulates a file upload
-- HTTP method, body, and adding a header

local argparse = require "argparse"
local puremagic = require('puremagic')


local parser = argparse("script", "Post benchmarking.")
parser:option("-f --file", "Image file."):count("*")
parser:option("-d --data", "Form data."):count("*")

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

local Boundary = "----WebKitFormBoundary" .. randomString(16)
local BodyBoundary = "--" .. Boundary
local LastBoundary = "--" .. Boundary .. "--"
local CRLF = "\r\n"
local filenames
local fieldnames
local counter = 1

function read_txt_file(path)
    local file, errorMessage = io.open(path, "r")    
    if not file then 
        error("Could not read the file:" .. errorMessage .. "\n")
    end

    local content = file:read "*all"
    file:close()
    return content
end


function get_form_data(field, filename, isFile)
    local content = BodyBoundary .. CRLF .. "Content-Disposition: form-data; name=\"" .. field .. "\""
    if isFile then
        local file_content = read_txt_file(filename)
        local mimetype = puremagic.via_content(file_content, filename)
        content = content .. "; filename=\"" .. filename .. "\"" 
        content = content .. CRLF .. "Content-Type: " .. mimetype        
        content = content .. CRLF .. CRLF .. file_content
    else 
        content = content .. CRLF .. CRLF .. filename
    end 
    content = content .. CRLF
    return content 
end     


-- special functions here

function init(args)     
    local data = parser:parse(args)        
    filenames = data['file']      
    fieldnames = data['data']       

    wrk.method = "POST"    
    wrk.headers["Content-Type"] = "multipart/form-data; boundary=" .. Boundary

end 

function request()    

    -- round robin data
    local filename = filenames[(counter - 1) % (table.getn(filenames)) + 1]
    local fieldname = fieldnames[(counter - 1) % (table.getn(fieldnames)) + 1]

    -- update counter
    counter = counter + 1

    -- assign body 
    wrk.body = ""
    -- print(index,filename)    

    -- form files    
    for k, v in string.gmatch(filename, "([%w_]+)=([^&]*)") do        
        wrk.body = wrk.body .. get_form_data(k, v, true)
    end
    
    -- form fields
    for k, v in string.gmatch(fieldname, "([%w_]+)=([^&]*)") do        
        wrk.body = wrk.body .. get_form_data(k, v, false) 
    end
    
    -- last boundary
    wrk.body = wrk.body .. LastBoundary
        
    -- return request
    return wrk.format()
    
end

function response(status, headers, body)
    print(counter, body)    
end