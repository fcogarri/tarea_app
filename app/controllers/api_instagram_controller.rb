class ApiInstagramController < ApplicationController
    
    skip_before_filter  :verify_authenticity_token
    require 'httparty'

	def imageGet
	    respond_to do |format|
	    	tag = params.require(:tag)
	    	token = params.require(:access_token)
	    	
	    	response1 = HTTParty.get("https://api.instagram.com/v1/tags/"+tag+"/media/recent?access_token="+token).parsed_response
	    	response2 = HTTParty.get("https://api.instagram.com/v1/tags/"+tag+"?access_token="+token)
	    	tagInfo=getTagInfo(tag,token)
	    	lista=getLista(tag,token)
	    	#response =  { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
	    	
	     posts= procesarArreglo(lista)
	     metadata={
	         :total=>tagInfo['data']['media_count']
	     }
	     version='1'
	    # tagInfo['data'].each do |child|
	    #     metadata<<{
	    #         :total =>child['media_count']
	    #     }
	    # end
	    # 
	    	#response1['data'].each do |child|
	    	#	posts<<{
	    	#		:tags =>child['tags'],
	    	#		:username =>child['user']['username'],
	    	#		:likes => child['likes'],
	    	#		:url => child['images']['standard_resolution'],
	    	#		:caption => child['caption']['text']
	    	#	}
	    	#end
	    	format.json {render json: {metadata: metadata, posts: posts, version: version},status:200}
	    end
	end
	
	def getTagInfo(tag, token)
	    ruta=URI.parse("https://api.instagram.com/v1/tags/"+tag+"?access_token="+token)
	    response1= HTTParty.get(ruta).parsed_response
	    response1
	    
	end
	
	def getLista(tag, token)
	    ruta=URI.parse("https://api.instagram.com/v1/tags/"+tag+"/media/recent?access_token="+token)
	    response2= HTTParty.get(ruta).parsed_response
	    response2
	    
	end
	
	def procesarArreglo(lista)
	    posts= []
		lista['data'].each do |child|
			posts<<{
				:tags =>child['tags'],
				:username =>child['user']['username'],
				:likes => child['likes']['count'],
				:url => child['images']['standard_resolution']['url'],
				:caption => child['caption']['text']
			}
		end
		posts
	end

end
