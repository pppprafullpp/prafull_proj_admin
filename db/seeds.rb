admin = Admin.find_or_initialize_by(:name => 'Amit',:email => 'amit.pandey@spa-systems.com')
admin.password = Admin.encrypt('123456')
admin.save
admin = Admin.find_or_initialize_by(:name => 'Ram',:email => 'ram.garg@spa-systems.com')
admin.password = Admin.encrypt('123456')
admin.save
admin = Admin.find_or_initialize_by(:name => 'Apoorv',:email => 'apoorv@sp-assurance.com')
admin.password = Admin.encrypt('123456')
admin.save
