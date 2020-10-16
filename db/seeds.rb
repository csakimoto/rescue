# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

   Message.delete_all
   Provider.delete_all
   Provider.create(
            [
                      {send_url:'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1',active:true,percentage_used:0.70,actual_percentage_used:0.0,percentage_failed:0.0,count:0,failed_count:0,total_messages_sent:0},
                      {send_url:'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2',active:true,percentage_used:0.30,count:0,actual_percentage_used:0.0,percentage_failed:0.0,failed_count:0,total_messages_sent:0}
                      ]
                  )
