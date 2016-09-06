class Solr 
  
 class << self
   
    def index_data(data_info)
      if data_info.present?
        docxml = "<add>"
        index_data = {}
        
        if data_info.class.to_s == 'TestCategory'
          index_data['type'] = 'test_category'
          index_data['id'] = data_info.id
          index_data['name'] = data_info.name
          index_data['description'] = data_info.description
          index_data['status'] = data_info.status
          index_data['createdtime'] = Time.now.strftime('%FT%TZ') if data_info.new_record?
          index_data['cat_tests'] = data_info.category_tests

        end
        
        if data_info.class.to_s == 'Test'
          index_data['type'] = 'test'
          index_data['id'] = data_info.id
          index_data['name'] = data_info.name
          index_data['keywords'] = data_info.keywords
          index_data['description'] = data_info.description
          index_data['status'] = data_info.status

          index_data['createdtime'] = Time.now.strftime('%FT%TZ') if data_info.new_record?

          index_data['technical_name'] = data_info.technical_name
          index_data['test_method'] = data_info.test_method
          index_data['why'] = data_info.why
          index_data['when'] = data_info.when
          index_data['test_preparation'] = data_info.test_preparation
        end
        
        if data_info.class.to_s == 'LabTest'
          #abort 
          index_data['type'] = 'lab'
          index_data['id'] = data_info.lab.lab_id
          index_data['lab_tests'] = data_info.lab.lab_tests.collect{|lab_test| lab_test.test_id}.uniq
          
        end
        
        if data_info.class.to_s == 'Lab'
          index_data['type'] = 'lab'
          index_data['id'] = data_info.id
          index_data['lab_location_id'] = data_info.city_location_id
          index_data['lab_tests'] = data_info.lab_tests.collect{|lab_test| lab_test.test_id}.uniq                           
          index_data['status'] = data_info.status
          index_data['contact_name'] = data_info.contact_name
          index_data['lab_name'] = data_info.lab_name
          index_data['email'] = data_info.email
          index_data['mobile'] = data_info.mobile
          index_data['description'] = data_info.description
          index_data['landmark'] = data_info.landmark
          index_data['street_address'] = data_info.street_address
          index_data['city_id'] = data_info.city_id
          index_data['lab_seo_name'] = data_info.lab_seo_name
          index_data['listing_only'] = data_info.listing_only
          index_data['createdtime'] = Time.now.strftime('%FT%TZ') if data_info.new_record?
        end
        
        if data_info.class.to_s == 'Doctor'
          index_data['type'] = 'doctor'
          index_data['doctor_id'] = data_info.id
          
          index_data['id'] = data_info.id
          index_data['status'] = data_info.status
          index_data['name'] = data_info.first_name + (data_info.last_name.present? ? data_info.last_name : '')
          index_data['email'] = data_info.email
          index_data['mobile'] = data_info.mobile
          index_data['registration_number'] = data_info.registration_number
          index_data['registered_state_council'] = data_info.registered_state_council
          index_data['other_details'] = data_info.other_details
          index_data['speciality'] = data_info.speciality
          index_data['qualification'] = data_info.qualification
        end
        
        if data_info.class.to_s == 'DoctorAddress'
          
          index_data['type'] = 'doctor_address'
          index_data['id'] = data_info.id
          index_data['doctor_id'] = data_info.doctor_id
          index_data['status'] = data_info.status
          
          index_data['address1'] = data_info.address1
          index_data['address2'] = data_info.address2
          index_data['city_id'] = data_info.city_id
          index_data['location_id'] = data_info.city_location_id
          index_data['consultation_fee'] = data_info.consultation_fee
          index_data['doctor_status'] = data_info.doctor.status
          index_data['name'] = data_info.doctor.first_name + (data_info.doctor.last_name.present? ? data_info.doctor.last_name : '')
          index_data['email'] = data_info.doctor.email
          index_data['mobile'] = data_info.doctor.mobile
          index_data['registration_number'] = data_info.doctor.registration_number
          index_data['registered_state_council'] = data_info.doctor.registered_state_council
          index_data['other_details'] = data_info.doctor.other_details
          index_data['speciality'] = eval(data_info.doctor.speciality).compact.reject(&:blank?)
          index_data['qualification'] = eval(data_info.doctor.qualification).compact.reject(&:blank?)
          index_data['createdtime'] = Time.now.strftime('%FT%TZ') if data_info.new_record?
        end
        
        docxml += "<doc>"
        docxml += add_fields(index_data)
        docxml += "</doc>"
        docxml += "</add>"
        
        #raise APP_CONFIG[:solr_server].inspect
        url = URI.parse(APP_CONFIG[:solr_server])
        connection = Net::HTTP.new(url.host, url.port)
        solr_url = url.to_s + URI.escape("/update?stream.body="+docxml)
        p url.to_s + URI.escape("/update?stream.body="+docxml)
        result = connection.post(url.path + "/update", URI.escape("stream.body="+docxml+"&commit=true"))
        connection.get(url.path + "/update?softCommit=true")
      end
      
    end
    
    
    # new method for getting solr data depending on type (Used in AngularJs search page)
    def solr_home_data(searchterm, start, rows, sort='')
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      
      usertags = []

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      elsif(sort == 'listing_only')
        strsort = 'listing_only asc'
      end
     
     #begin
        queryterm = searchterm
        row_str = rows.present? ? "&rows="+rows.to_s : '&rows=10'
        addtype = removetype = createdByType = additionalInCondition = ""
        #addtype = "type:lab"
        
        url = URI.parse(APP_CONFIG[:solr_server])
        connection = Net::HTTP.new(url.host, url.port)
        
        strparams = URI.escape("start="+start.to_s+row_str+"&wt=ruby&indent=on&sort="+strsort+"&q=" + queryterm).gsub("__x__", "%2B")
        result      = connection.post(url.path + "/select", strparams)
        solr_url =  "#{url.path}/select?#{strparams}"
        p solr_url.inspect
        
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
      
      #rescue => e
       # data    = Hash.new
      #end
      
      return data
    
    end


    def add_fields(hsh, addtype = 'xml')
      str = ''

      if addtype == 'xml'
        hsh.each { |key, val|

          if val.kind_of?(Hash)
            if !val.empty?
              str += "<field name='"+key.to_s+"'>"+val.to_s+"</field>"
            end
          elsif val.kind_of?(Array)
            val.each do |v|
               str += "<field name='"+key.to_s+"'>"+v.to_s+"</field>"
            end    
          elsif key!= '' && val!=''
            str += "<field name='"+key.to_s+"'>"+val.to_s+"</field>"
          end
        }
      else
        hsh.each { |key, val|

          if val.kind_of?(Hash)
            if !val.empty?
              str += "&literal."+key.to_s+"="+val.to_s
            end
          elsif val.kind_of?(Array)
            val.each do |v|
              str += "&literal."+key.to_s+"="+v.to_s
            end  
              
          elsif key!= '' && val!=''
            str += "&literal."+key.to_s+"="+val.to_s
          end
        }
      end
      return str
    end




    def get_file_by_pg_ids(searchterm, start, rows, username, fq, type)
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)

      fq = URI.unescape(fq)
      queryterm = URI.unescape("pg_id:(#{searchterm.join('+or+')})")
      qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      fl = 'attachmenturl,id,location,type,attachmentname,maintext,fileauthors,description,pg_id,parentid,createdby,filetype,url,extension,createdtime'
      row_str = rows.present? ? "&rows="+rows.to_s : '&rows=10000'
      begin
        strparams = URI.escape("qf=" + qfstr + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on&q=" + queryterm+"&fq=" + fq +"&fl=" + fl).gsub("__x__", "%2B")
        #puts "*******************#{strparams}****************************************"
        result      = connection.post(url.path + "/select", strparams)
        solr_url =  "#{url.path}/select?#{strparams}"
        p solr_url.inspect
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
      rescue => e
        puts "*******************#{e.inspect}*****************"
        #raise e.inspect
      end
      return data
    end

    def get_file_facets_by_pg_ids(pg_ids,searchterm, start, rows, sort, username, fq, parent_url, requrl = '', type, show_all)
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      follower    = Follower.followings(username,1) << username
      followerstr = follower.join(" ")

      followers_boost = follower.collect { |f|
        "(id:person-#{f})^20"
      }

      #usertags = Usertags.top_tags(username)
      usertags = []

      followers_boost = followers_boost + usertags.collect do |t|
        t[0] = t[0].gsub("&", "")
        "(tags:#{t[0]})^#{t[1]}"
      end

      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      faceters  = "&facet=true&facet.field=type&facet.field=createdby&facet.field=extension&facet.field=metadata&facet.field=fileauthors&facet.mincount=1&facet.query=createdtime:[NOW-1HOUR TO NOW]&facet.query=createdtime:[NOW-1DAY TO NOW]&facet.query=createdtime:[NOW-7DAYS TO NOW]&facet.query=createdtime:[NOW-1MONTH TO NOW]&facet.query=createdtime:[NOW-1YEAR TO NOW]"
      if true
        #always include external links description for now
        queryterm = URI.unescape("pg_id:(#{pg_ids.join('+or+')})")
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      else
        queryterm = URI.unescape("pg_id:(#{pg_ids.join('+or+')})")
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      end

      parenturl = ''
      if parent_url.present?
        parenturl = "url:#{parent_url}/*"
      end

      logger.info 'query term...........' + queryterm.inspect
      row_str = rows.present? ? "&rows="+rows.to_s : ''

      additionalInCondition = additionalOutCondition = addtype = additionalOther = ''

      if show_all == "false"
        #user_file_permission = ChangePermission.get_search_file_permissions(username,Community::TYPES_ARRAY[0..4],true)
        #additionalOutCondition = user_file_permission.present? ? "-((type:file) AND !pg_id:(#{user_file_permission.join(' ')}))" : ''
        #additionalInCondition = user_file_permission.present? ? "((type:file) AND pg_id:(#{user_file_permission.join(' ')}))" : ''
        #additionalOutCondition = user_file_permission.present? ? "-((type:file) AND !pg_id:(#{user_file_permission.join(' ')}))" : ''
        additionalInCondition = "(type:file)"
      else
        additionalInCondition = "(type:file)"
      end

      begin
        if fq.present?
          fq = URI.unescape(fq)
          #requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          requrl = URI.unescape(requrl.sub("&q=#{searchterm}", ""))
          strsort = 'createdtime desc' if fq == 'type:training' && sort == ''
          #####################################################
          #requrl = requrl + " AND location:publish"
          ######################################################
          if type.present?
            case type
              when "others"
                additionalOther = " OR (type:(file person training)) "
              when "file"
                addtype = "#{additionalInCondition}"
              when "facets"
                addtype = "#{additionalOutCondition}"
              else
                addtype = "(type:#{type})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end

          minusresults = "#{addtype}-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))#{additionalOther}OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm +"&"+requrl+"&fq=" + minusresults).gsub("__x__", "%2B")
          logger.info 'path1...........' +  url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)
        else
          if type.present?
            case type
              when "others"
                additionalOther = " OR (type:(file person training)) "
              when "file"
                addtype = "#{additionalInCondition}"
              when "facets"
                addtype = "#{additionalOutCondition}"
              else
                addtype = "(type:#{type})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end

          minusresults = "#{addtype}-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))#{additionalOther}OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm + "&fq= " + minusresults).gsub("__x__", "%2B")
          p 'path2...........' + url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)
        end
        solr_url =  "#{url.path}/select?#{strparams}"
        p solr_url.inspect
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
        p " URL of the spell checker"
        p URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+"")
        resultdum  = connection.get(url.path + URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+""))
        datadum    = eval(resultdum.body)
      rescue => e
        data    = Hash.new
        datadum = Hash.new
      end
      return data, datadum
    end



    # new method for getting solr data depending on type (Used in AngularJs search page)
    def solr_data_by_type(searchterm, start, rows, sort, username, fq)

      puts "---------TYPE INFORMATION GOES HERE-----------#{type}----"
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      follower    = Follower.followings(username,1) << username
      followerstr = follower.join(" ")

      followers_boost = follower.collect { |f|
        "(id:person-#{f})^20"
      }

      #usertags = Usertags.top_tags(username)
      usertags = []

      followers_boost = followers_boost + usertags.collect do |t|
        t[0] = t[0].gsub("&", "")
        "(tags:#{t[0]})^#{t[1]}"
      end

      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      if true
        #always include external links description for now
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      else
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      end

      parenturl = ''
      if parent_url.present?
        parenturl = "url:#{parent_url}/*"
      end

      logger.info 'query term...........' + queryterm.inspect
      row_str = rows.present? ? "&rows="+rows.to_s : '&rows=10000'
      begin
        addtype = removetype = createdByType = additionalInCondition = ""

        if (show_all == "false" && (type == 'file' || fq == 'file'))
          #user_file_permission = ChangePermission.get_search_file_permissions(username,Community::TYPES_ARRAY[0..4],true)
          #additionalInCondition = user_file_permission.present? ? " AND pg_id:(#{user_file_permission.join(' ')})" : ''
        end

        if fq.present?
          fq = URI.unescape(fq)
          #requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          requrl = URI.unescape(requrl.sub("&q=#{searchterm}", ""))

          puts "--ALL THE REFINE SEARCH PARAMETER GOES HERE---#{requrl.inspect}"

          strsort = 'createdtime desc' if fq == 'type:training' && sort == ''

          #additionalCondition = (fq == "others") ? " OR (type:(file person training)) " : ""
          #addtype = (fq.present? && fq.to_s != "others") ? "type:#{fq}" : ""
          #fqaddition = (fq.present? && fq.to_s != "others") ? "&fq=" + fq : "&fq="

          #minusresults = "#{addtype} -((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) #{additionalCondition} OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          #strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on&sort="+strsort+"&q=" + queryterm + fqaddition + " " + minusresults + parenturl).gsub("__x__", "%2B")

          # find conditional search

          if type.present?
            if type == "others"
              additionalCondition = " OR (type:(file person training)) "
            else
              addtype = "(type:#{type}#{additionalInCondition})"
            end
          end
          
          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end
          
          minusresults = "#{addtype} -((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) #{additionalCondition} OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"

          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on&sort="+strsort+"&q=" + queryterm + "&" + requrl + "&fq="+ minusresults).gsub("__x__", "%2B")

      

          logger.info "path1......#{addtype.inspect}....." +  url.path + "/select?" + strparams

          result      = connection.post(url.path + "/select", strparams)
        else
          puts "---------TYPE INFORMATION GOES HERE 2-----------#{type}----"
          if type.present?
            if type == "others"
              additionalCondition = " OR (type:(file person training)) "
            else
              addtype = "type:#{type}#{additionalInCondition}"
            end
          end
          
          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end
          
          minusresults = "#{addtype} -((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) #{additionalCondition} OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on&sort="+strsort+"&q=" + queryterm  + "&fq=" + minusresults).gsub("__x__", "%2B")
          result      = connection.post(url.path + "/select", strparams)
        end
        solr_url =  "#{url.path}/select?#{strparams}"
        p solr_url.inspect
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
      rescue => e
        data    = Hash.new
      end
      return data
    end

    # method for getting facets and spell checks in angularJs search page (Used in AngularJs search page)
    def solr_facets_data(searchterm, start, rows, sort, username, fq, parent_url, requrl = '', type, show_all)
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      follower    = Follower.followings(username,1) << username
      followerstr = follower.join(" ")

      followers_boost = follower.collect { |f|
        "(id:person-#{f})^20"
      }

      #usertags = Usertags.top_tags(username)
      usertags = []

      followers_boost = followers_boost + usertags.collect do |t|
        t[0] = t[0].gsub("&", "")
        "(tags:#{t[0]})^#{t[1]}"
      end

      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      faceters  = "&facet=true&facet.field=type&facet.field=createdby&facet.field=extension&facet.field=metadata&facet.field=fileauthors&facet.mincount=1&facet.query=createdtime:[NOW-1HOUR TO NOW]&facet.query=createdtime:[NOW-1DAY TO NOW]&facet.query=createdtime:[NOW-7DAYS TO NOW]&facet.query=createdtime:[NOW-1MONTH TO NOW]&facet.query=createdtime:[NOW-1YEAR TO NOW]"
      if true
        #always include external links description for now
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      else
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      end

      parenturl = ''
      if parent_url.present?
        parenturl = "url:#{parent_url}/*"
      end

      logger.info 'query term...........' + queryterm.inspect
      row_str = rows.present? ? "&rows="+rows.to_s : ''

      additionalInCondition = additionalOutCondition = addtype = additionalOther = ''

      if show_all == "false"
        #user_file_permission = ChangePermission.get_search_file_permissions(username,Community::TYPES_ARRAY[0..4],true)
        #additionalOutCondition = user_file_permission.present? ? "-((type:file) AND !pg_id:(#{user_file_permission.join(' ')}))" : ''
        #additionalInCondition = user_file_permission.present? ? "((type:file) AND pg_id:(#{user_file_permission.join(' ')}))" : ''
        #additionalOutCondition = user_file_permission.present? ? "-((type:file) AND !pg_id:(#{user_file_permission.join(' ')}))" : ''
        additionalInCondition = "(type:file)"
      else
        additionalInCondition = "(type:file)"
      end

      begin
        if fq.present?
          fq = URI.unescape(fq)
          #requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          requrl = URI.unescape(requrl.sub("&q=#{searchterm}", ""))
          strsort = 'createdtime desc' if fq == 'type:training' && sort == ''
          #####################################################
          #requrl = requrl + " AND location:publish"
          ######################################################
          if type.present?
            case type
              when "others"
                additionalOther = " OR (type:(file person training)) "
              when "file"
                addtype = "#{additionalInCondition}"
              when "facets"
                addtype = "#{additionalOutCondition}"
              else
                addtype = "(type:#{type})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end

          minusresults = "#{addtype}-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))#{additionalOther}OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm +"&"+requrl+"&fq=" + minusresults).gsub("__x__", "%2B")
          logger.info 'path1...........' +  url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)
        else
          if type.present?
            case type
              when "others"
                additionalOther = " OR (type:(file person training)) "
              when "file"
                addtype = "#{additionalInCondition}"
              when "facets"
                addtype = "#{additionalOutCondition}"
              else
                addtype = "(type:#{type})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end

          minusresults = "#{addtype}-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))#{additionalOther}OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm + "&fq= " + minusresults).gsub("__x__", "%2B")
          p 'path2...........' + url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)
        end
        solr_url =  "#{url.path}/select?#{strparams}"
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
        p " URL of the spell checker"
        p URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+"")
        resultdum  = connection.get(url.path + URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+""))
        datadum    = eval(resultdum.body)
      rescue => e
        data    = Hash.new
        datadum = Hash.new
      end
      return data, datadum
    end

    ## query for advanced search
    def adv_solr_data_by_type(searchterm, start, rows, sort, username, fq, parent_url, requrl = '', type, show_all)
      puts "---------TYPE INFORMATION GOES HERE-----------#{type}----"
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      follower    = Follower.followings(username,1) << username
      followerstr = follower.join(" ")

      followers_boost = follower.collect { |f|
        "(id:person-#{f})^20"
      }

      #usertags = Usertags.top_tags(username)
      usertags = []

      followers_boost = followers_boost + usertags.collect do |t|
        t[0] = t[0].gsub("&", "")
        "(tags:#{t[0]})^#{t[1]}"
      end

      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      if true
        #always include external links description for now
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      else
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      end

      parenturl = ''
      if parent_url.present?
        parenturl = "url:#{parent_url}/*"
      end

      logger.info 'query term...........' + queryterm.inspect
      row_str = rows.present? ? "&rows="+rows.to_s : '&rows=10000'
      begin
        addtype = removetype = createdByType = additionalInCondition = ""

        if fq.present?

          fq = URI.unescape(fq)
          #requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          requrl = URI.unescape(requrl.sub("&q=#{searchterm}", ""))

          puts "--ALL THE REFINE SEARCH PARAMETER GOES HERE---#{requrl.inspect}"
          if type.present?
            if type == "others"
              additionalCondition = " OR (type:(file person training)) "
            else
              addtype = "(type:#{type}#{additionalInCondition})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end
          strsort = 'createdtime desc' if fq == 'type:training' && sort == ''
          queryterm = queryterm.gsub('%3A',':').gsub('%2B',' ').gsub('%2A','*')
          minusresults = "#{addtype} -((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) #{additionalCondition} OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"

          strparams = URI.escape("qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on&sort="+strsort+"&q=" + queryterm + "&" + requrl + "&fq="+ minusresults).gsub("__x__", "%2B")

          logger.info "path1......#{addtype.inspect}....." +  url.path + "/select?" + strparams

          result      = connection.post(url.path + "/select", strparams)
        else
          if type.present?
            if type == "others"
              additionalCondition = " OR (type:(file person training)) "
            else
              addtype = "type:#{type}#{additionalInCondition}"
            end
          end
          puts "------QUERY TERM-------------------------#{queryterm}"
          queryterm = queryterm.gsub('%3A',':').gsub('%2B',' ').gsub('%2A','*')
          puts "------QUERY TERM NEW-------------------------#{queryterm}"
          minusresults = "#{addtype} -((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) #{additionalCondition} OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on&sort="+strsort+"&q=" + queryterm  + "&fq=" + minusresults).gsub("__x__", "%2B")
          result      = connection.post(url.path + "/select", strparams)
        end
        solr_url =  "#{url.path}/select?#{strparams}"
        puts "***SOLR URL*****************#{solr_url}**********"
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
      rescue => e
        puts "*****EXCEPTION*****************************************#{e.inspect}"
        data    = Hash.new
      end
      return data
    end

    def adv_solr_facets_data(searchterm, start, rows, sort, username, fq, parent_url, requrl = '', type, show_all)
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      follower    = Follower.followings(username,1) << username
      followerstr = follower.join(" ")

      followers_boost = follower.collect { |f|
        "(id:person-#{f})^20"
      }

      #usertags = Usertags.top_tags(username)
      usertags = []

      followers_boost = followers_boost + usertags.collect do |t|
        t[0] = t[0].gsub("&", "")
        "(tags:#{t[0]})^#{t[1]}"
      end

      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      faceters  = "&facet=true&facet.field=type&facet.field=createdby&facet.field=extension&facet.field=metadata&facet.field=fileauthors&facet.mincount=1&facet.query=createdtime:[NOW-1HOUR TO NOW]&facet.query=createdtime:[NOW-1DAY TO NOW]&facet.query=createdtime:[NOW-7DAYS TO NOW]&facet.query=createdtime:[NOW-1MONTH TO NOW]&facet.query=createdtime:[NOW-1YEAR TO NOW]"
      if true
        #always include external links description for now
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      else
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      end

      parenturl = ''
      if parent_url.present?
        parenturl = "url:#{parent_url}/*"
      end

      logger.info 'query term...........' + queryterm.inspect
      row_str = rows.present? ? "&rows="+rows.to_s : ''

      additionalInCondition = additionalOutCondition = addtype = additionalOther = ''

      if show_all == "false"
        #user_file_permission = ChangePermission.get_search_file_permissions(username,Community::TYPES_ARRAY[0..4],true)
        #additionalOutCondition = user_file_permission.present? ? "-((type:file) AND !pg_id:(#{user_file_permission.join(' ')}))" : ''
        #additionalInCondition = user_file_permission.present? ? "((type:file) AND pg_id:(#{user_file_permission.join(' ')}))" : ''
        #additionalOutCondition = user_file_permission.present? ? "-((type:file) AND !pg_id:(#{user_file_permission.join(' ')}))" : ''
        additionalInCondition = "(type:file)"
      else
        additionalInCondition = "(type:file)"
      end

      begin
        if fq.present?
          fq = URI.unescape(fq)
          #requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          requrl = URI.unescape(requrl.sub("&q=#{searchterm}", ""))
          strsort = 'createdtime desc' if fq == 'type:training' && sort == ''
          #####################################################
          #requrl = requrl + " AND location:publish"
          ######################################################
          if type.present?
            case type
              when "others"
                additionalOther = " OR (type:(file person training)) "
              when "file"
                addtype = "#{additionalInCondition}"
              when "facets"
                addtype = "#{additionalOutCondition}"
              else
                addtype = "(type:#{type})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end
          queryterm = queryterm.gsub('%3A',':').gsub('%2B',' ').gsub('%2A','*')
          minusresults = "#{addtype}-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))#{additionalOther}OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm +"&"+requrl+"&fq=" + minusresults).gsub("__x__", "%2B")
          logger.info 'path1...........' +  url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)
        else
          if type.present?
            case type
              when "others"
                additionalOther = " OR (type:(file person training)) "
              when "file"
                addtype = "#{additionalInCondition}"
              when "facets"
                addtype = "#{additionalOutCondition}"
              else
                addtype = "(type:#{type})"
            end
          end

          if(parenturl.present?)
            addtype = addtype.present? ? ("#{addtype} AND #{parenturl}") : parenturl
          end
          queryterm = queryterm.gsub('%3A',':').gsub('%2B',' ').gsub('%2A','*')
          minusresults = "#{addtype}-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))#{additionalOther}OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+row_str+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm + "&fq= " + minusresults).gsub("__x__", "%2B")
          p 'path2...........' + url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)
        end
        solr_url =  "#{url.path}/select?#{strparams}"
        unless result.code.to_s == '200'
          SolrException.create(:solr_url => solr_url, :status_code => result.code.to_s, :solr_exception => result.body.to_s)
        end
        data       = eval(result.body)
        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
        p " URL of the spell checker"
        p URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+"")
        resultdum  = connection.get(url.path + URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+""))
        datadum    = eval(resultdum.body)
      rescue => e
        data    = Hash.new
        datadum = Hash.new
      end
      return data, datadum
    end


    def query_solr(searchterm, start, rows, sort, username, fq, parent_url, requrl = '')
      
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
     
      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      logger.info 'query term...........' + queryterm.inspect

      begin
        if fq.to_s != ''
          requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          strsort = 'createdtime desc' if fq == 'type:training' && sort == ''
          #####################################################
          #requrl = requrl + " AND location:publish"
          ######################################################

          minusresults = "-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm + "&" + requrl + " " + minusresults + parenturl).gsub("__x__", "%2B")

          logger.info 'path1...........' +  url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)

        else

          #minusresults = "-(type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + "))"
          minusresults = "-((type:(buzz event question_answer meeting) AND -createdby:(" + followerstr.to_s + ")) OR (type:file AND (location:workflow OR location:expired OR location:publish_deleted)) OR (type:folder AND location:publish_deleted))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=" + queryterm + "&fq= " + minusresults + parenturl).gsub("__x__", "%2B")
          #abort 'path2...........' + url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)

        end

        data       = eval(result.body)

        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"

        resultdum  = connection.get(url.path + URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+""))
        datadum    = eval(resultdum.body)
      rescue => e
        data    = Hash.new
        datadum = Hash.new
      end
      return data, datadum
    end

    def adv_query_solr(searchterm, start, rows, sort, username, fq, requrl = '')
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      faceters  = "&facet=true&facet.field=type&facet.field=createdby&facet.field=extension&facet.field=metadata&facet.field=fileauthors&facet.mincount=1&facet.query=createdtime:[NOW-1HOUR TO NOW]&facet.query=createdtime:[NOW-1DAY TO NOW]&facet.query=createdtime:[NOW-7DAYS TO NOW]&facet.query=createdtime:[NOW-1MONTH TO NOW]&facet.query=createdtime:[NOW-1YEAR TO NOW]"

      begin
        if fq.to_s != ''
          requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))
          result      = connection.post(url.path + "/select", URI.escape("omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on&hl=true&hl.fl=maintext&hl.simple.pre=<span class=highlight>&hl.simple.post=</span>"+faceters+"&sort="+strsort+"&q=("+searchterm+")&"+requrl))
        else
          result      = connection.post(url.path + "/select", URI.escape("omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on&hl=true&hl.fl=maintext&hl.simple.pre=<span class=highlight>&hl.simple.post=</span>"+faceters+"&sort="+strsort+"&q=("+searchterm+")"))
        end

        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"
        puts "###################################################################################"
        data       = eval(result.body)

        resultdum  = connection.get(url.path + URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+""))
        datadum    = eval(resultdum.body)
      rescue => e
        data    = Hash.new
        datadum = Hash.new
      end

      return data, datadum
    end

    def apply_filter(searchterm, start, rows, sort, username, fq, requrl = '')
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      elsif(sort == 'folderfirst')
        strsort = 'type desc, createdtime desc'
      elsif(sort == 'folderfirst_bydate_asc')
        strsort = 'type desc, createdtime asc'
      elsif(sort == 'folderfirst_byname_asc')
        strsort = 'type desc, maintext asc'
      end

      faceters = ''
      queryterm = "+"+searchterm

      begin
        if fq.to_s != ''
          #  abort url.path + URI.escape("/select/?omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=("+queryterm+")"+requrl)
          result      = connection.get(url.path + URI.escape("/select/?omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=("+queryterm+")"+requrl))
        else
          #abort url.path + URI.escape("/select/?omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=("+queryterm+")")
          result      = connection.get(url.path + URI.escape("/select/?omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=("+queryterm+")"))
        end

        data       = eval(result.body)
      rescue => e
        data    = Hash.new
      end

      return data
    end

    def find_related(params)
      data = Hash.new
      return data if params['tags'].blank?

      params['max'] = 5 if params['max'].nil?
      params['type'] = 'file' if params['type'].nil?
      tags = params['tags'].join(' OR tags:')

      begin
        url         = URI.parse(APP_CONFIG[:solr_server])
        connection  = Net::HTTP.new(url.host, url.port)

        #abort url.to_s + URI.escape("/select/?omitHeader=true&version=2.2&start=0&rows=#{params['max']}&wt=ruby&indent=on&q=tags:#{tags}&fq=type:#{params['type']}")
        result      = connection.get(url.path + URI.escape("/select/?omitHeader=true&version=2.2&start=0&rows=#{params['max']}&wt=ruby&indent=on&q=tags:#{tags}&fq=type:#{params['type']}"))

        data       = eval(result.body)
      rescue => e
        data    = Hash.new
      end

      return data
    end

    def search_for(searchterm, rows = UserSuggestion::MAX_DOC_PER_TAG, custom_params="fq=type:file&fl=id,score")
      return [] if searchterm.blank?

      queryterm = "+#{searchterm}* OR attachmentcontent:+#{searchterm}* OR tags:*#{searchterm}* OR description:#{searchterm}"

      begin
        url = URI.parse(APP_CONFIG[:solr_server])
        connection  = Net::HTTP.new(url.host, url.port)

        result = connection.get(url.path + URI.escape("/select/?omitHeader=true&version=2.2&start=0&rows=#{rows}&wt=ruby&indent=on&q=#{queryterm}&#{custom_params}"))

        data       = eval(result.body)
      rescue => e
        data    = Hash.new
      end

      return data
    end

    def get_by_id(id)
      begin
        url = URI.parse(APP_CONFIG[:solr_server])
        connection = Net::HTTP.new(url.host, url.port)
        result = connection.get(url.path + URI.escape("/select/?omitHeader=true&q=id:#{id.to_s}&wt=ruby"))
        data   = eval(result.body)
      rescue => e
        data    = Hash.new
      end

      if data["response"]["docs"].present?
        return data["response"]["docs"]
      else
        return []
      end
    end

    def index_skills(key, skills)
      hsh = Streams.hash_with_defaulthash()

      hsh['id']                 = "person-"+ key.to_s
      hsh['type']               = "person"
      hsh['skills']             = skills.join(',')
      docxml = "<add><doc>"
      docxml += add_fields(hsh)
      docxml += "</doc></add>"

      url = URI.parse(APP_CONFIG[:solr_server])
      connection = Net::HTTP.new(url.host, url.port)
      result = connection.get(url.path + URI.escape("/update?stream.body="+docxml))
      if !result.blank? && result.code.to_s == '400'
        failed = true
      end

      connection.get(url.path + "/update?softCommit=true")
      false if failed
    end

    def fetch_skills(key)
      begin
        url = URI.parse(APP_CONFIG[:solr_server])
        connection = Net::HTTP.new(url.host, url.port)
        result = connection.get(url.path + URI.escape("/select/?omitHeader=true&q=id:person-#{key.to_s}&wt=ruby"))
        data   = eval(result.body)
      rescue => e
        data    = Hash.new
      end

      if data["response"].present? and data["response"]["docs"].present?
        return data["response"]["docs"][0]["skills"] || Array.new
      else
        return []
      end
    end

    def exists?(key)
      begin
        url = URI.parse(APP_CONFIG[:solr_server])
        connection = Net::HTTP.new(url.host, url.port)
        result = connection.get(url.path + URI.escape("/select/?omitHeader=true&q=id:#{key.to_s}&wt=ruby"))
        data   = eval(result.body)
      rescue => e
        data    = Hash.new
      end

      data["response"]["docs"].present?
    end

    # method for finding the directory summary
    def dir_summary(folder_url, status = 'publish')
      status = 'publish' if status.nil?
      #solr_core = (Rails.env == "production") ? "satori00" :"collection1"
      #url = APP_CONFIG[:solr_server] + "/#{solr_core}/select?q=url:#{folder_url}/* AND (type:folder OR (type:file AND location:#{status}))&rows=0&wt=ruby&indent=true&facet=true&facet.field=type&facet.prefix=f&facet.sort=index"
      if folder_url.present?
        url = APP_CONFIG[:solr_server] + "/select?q=url:#{folder_url}/* AND (type:folder OR (type:file AND location:#{status}))&rows=0&wt=ruby&indent=true&facet=true&facet.field=type&facet.prefix=f&facet.sort=index"
        response = Net::HTTP.get_response(URI.parse(URI.encode(url)))
        return eval(response.body)
      else 
        []
      end     
    end


    ## Newly Added API for Mobile Devices

    def api_query_solr(searchterm, start, rows, sort, username, fq, parent_url, requrl = '')
      url         = URI.parse(APP_CONFIG[:solr_server])
      connection  = Net::HTTP.new(url.host, url.port)
      #follower    = Follower.followings(username,1).collect {|sm| sm.following_id } << username
      follower    = Follower.followings(username,1) << username
      followerstr = follower.join(" ")

      followers_boost = follower.collect { |f|
        "(id:person-#{f})^20"
      }

      usertags = Usertags.top_tags(username)

      followers_boost = followers_boost + usertags.collect do |t|
        t[0] = t[0].gsub("&", "")
        "(tags:#{t[0]})^#{t[1]}"
      end

      usertags_params = ''

      strsort = ''
      if(sort == 'ctd')
        strsort = 'createdtime desc'
      elsif(sort == 'cta')
        strsort = 'createdtime asc'
      elsif(sort == 'cba')
        strsort = 'createdby asc'
      end

      faceters  = "&facet=true&facet.field=type&facet.field=createdby&facet.field=extension&facet.field=metadata&facet.field=fileauthors&facet.mincount=1&facet.query=createdtime:[NOW-1HOUR TO NOW]&facet.query=createdtime:[NOW-1DAY TO NOW]&facet.query=createdtime:[NOW-7DAYS TO NOW]&facet.query=createdtime:[NOW-1MONTH TO NOW]&facet.query=createdtime:[NOW-1YEAR TO NOW]"
      if true
        #always include external links description for now
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      else
        queryterm = searchterm
        qfstr = "id^10 maintext^10 linkdesc^1.0 attachmentcontent^1.0 tags^7.5 description^5.0"
      end

      parenturl = ''
      if parent_url.present?
        parenturl = " url:#{parent_url}/*"
      end

      logger.info 'query term...........' + queryterm.inspect

      begin
        if fq.to_s != ''
          requrl = URI.unescape(requrl.sub(/q=([^&]*)&/, ""))

          selectresults = "((type:person) OR (type:file AND location:publish))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=(" + queryterm + ")&" + requrl + " " + selectresults + parenturl).gsub("__x__", "%2B")
          logger.info 'path1...........' +  url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)

        else

          selectresults = "((type:person) OR (type:file AND location:publish))"
          strparams = URI.escape("defType=dismax&qf=" + qfstr + "&bq=" + followers_boost.join(',') + "&omitHeader=true&version=2.2&start="+start.to_s+"&rows="+rows.to_s+"&wt=ruby&indent=on"+faceters+"&sort="+strsort+"&q=(" + queryterm + ")&fq=" + selectresults + parenturl).gsub("__x__", "%2B")
          logger.info 'path2...........' + url.path + "/select?" + strparams
          result      = connection.post(url.path + "/select", strparams)

        end

        data       = eval(result.body)

        raise "Bad Request" if result.class.to_s == "Net::HTTPBadRequest"

        resultdum  = connection.get(url.path + URI.escape("/spell?omitHeader=true&version=2.2&wt=ruby&spellcheck=true&spellcheck.collate=true&spellcheck.build=true&q=+"+searchterm+""))
        datadum    = eval(resultdum.body)
      rescue => e
        data    = Hash.new
        datadum = Hash.new
      end
      return data, datadum
    end

  end
end
