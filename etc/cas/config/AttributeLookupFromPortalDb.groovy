import groovy.sql.Sql

class AttributeLookupFromPortalDb {
    // configure here
    static url = 'jdbc:mysql://qa6-box.dev.coredial.com/portal?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false&serverTimezone=US/Eastern&zeroDateTimeBehavior=CONVERT_TO_NULL'
    static user = 'voiceaxis'
    static password = 'dr0az3eh'
    static driver = 'com.mysql.cj.jdbc.Driver'

    // stuff is done here
    def Map<String, List<Object>> run ( final Object... args ) {
        def attributes = args[0]
        def logger = args[1]
        // test for authentication method -- we only want to run lookup for Google logins
        if ( attributes['access_token'] ) {
            logger.debug( "Current attributes received are {}", attributes )
            try {
                def sql = Sql.newInstance( url, user, password, driver )
                def row = sql.firstRow( """
                    select 
                      u.userId uid,
                      u.username userName,
                      u.firstName givenName,
                      u.lastName sn,
                      concat(u.firstName, ' ', u.lastName) displayName,
                      u.email mail,
                      u.enabled enabled,
                      if(u.enabled=1,0,1) disabled,
                      u.lastLoginTime lastLoginTime,
                      u.userType userType,
                      u.isSalesRep isSalesRep,
                      u.contactType contactType,
                      u.alias alias,
                      b.description context,
                      c.companyName companyName,
                      o.description organizationName,
                      r.name roleName
                    from portal.user u 
                    left join portal.branch b on u.branchId=b.branchId 
                    left join portal.customer c on u.customerId=c.customerId 
                    left join portal.organization o on u.organization_id=o.organization_id 
                    left join portal.role r on u.role_id=r.role_id 
                    where u.username=? """, [ attributes['emails'][0].getEmail() ] )
                if ( row ) {
                    logger.debug( "Retrieved attributes from database: {}", row )
                    def newattrs = [:]
                    row.each{ k, v -> newattrs[k] = v }
                    logger.debug( "New attributes returned are {}", newattrs )
                    sql.close()
                    return newattrs
                }
                sql.close()
            }
            catch ( java.sql.SQLException ex ) {
                logger.warn( "Error retrieving attributes from database: {}", ex.getMessage() )
            }
        }
        // for everyone else, leave unmodified
        logger.debug( "Leaving attributes unmodified: {}", attributes )
        return attributes
    }
}
