/********** Snowflake Session and Policies **********/


USE ROLE USERADMIN;
-- Always use a useradmin/its child roles while creating or altering users/roles.

CREATE ROLE POLICY_ADMIN;

USE ROLE SECURITYADMIN;
-- Always use security admin while performing grants.

GRANT USAGE ON DATABASE SNOW_DEV TO ROLE POLICY_ADMIN;
GRANT USAGE ON SCHEMA SNOW_DEV.SNOW_CORE TO ROLE POLICY_ADMIN;
GRANT APPLY SESSION POLICY ON ACCOUNT TO ROLE POLICY_ADMIN;

--** Optionally u can apply the session polciy on a user level
--** Need --> GRANT APPLY SEESION POLICY ON USER "< user_name >";


USE ROLE USERADMIN;

GRANT ROLE POLICY_ADMIN TO ROLE USERADMIN;
--** Granting the role to the parent role is very necessary to create a parent-child relation otherwise you cannot switch to the role.

USE ROLE POLICY_ADMIN;
--** Even though we grant it, the current role will not inherit the parent qualities.

CREATE SESSION POLICY SNOW_DEV.SNOW_CORE.SNOW_SESSION_POLICY
SESSION_UI_IDLE_TIMEOUT_MINS = 5 ; -- Will throw error as we don't have access

-- Need to provide access to operate 
SHOW GRANTS ON ROLE POLICY_ADMIN;

USE ROLE SECURITYADMIN;

GRANT CREATE SESSION POLICY ON SCHEMA SNOW_DEV.SNOW_CORE TO ROLE POLICY_ADMIN;

USE ROLE POLICY_ADMIN;


CREATE SESSION POLICY SNOW_DEV.SNOW_CORE.SNOW_SESSION_POLICY
SESSION_UI_IDLE_TIMEOUT_MINS = 5 ;

--** Applying session policy on account level

ALTER ACCOUNT SET SESSION POLICY SNOW_DEV.SNOW_CORE.SNOW_SESSION_POLICY;

--** The user will be logged out post 5 mins

--** We cannot drop the session policy directly as it is associated with the object. We need to unset them all and then drop it 

ALTER ACCOUNT UNSET SESSION POLICY;

DROP SESSION POLICY SNOW_DEV.SNOW_CORE.SNOW_SESSION_POLICY;


--** Note: We can check session policy information on ACCOUNT_USAGE.SESSION_POLICIES;

SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.SESSION_POLICIES;
