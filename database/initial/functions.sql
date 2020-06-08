-- functions of user
CREATE OR REPLACE FUNCTION per_finance_data.user_add(
    param_email VARCHAR,
    param_password TEXT,
    param_role_id INT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        user_id INT;
    BEGIN
        IF EXISTS(
            SELECT
                usr.email
            FROM
                per_finance_data.users usr
            WHERE
                usr.email = param_email
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO
                per_finance_data.users(email, password, role_id)
            VALUES
                (param_email, param_password, param_role_id)
            RETURNING id
      		INTO STRICT user_id;

        
        END IF;
        local_is_successful :='1';
        IF (param_role_id = 2) THEN PERFORM per_finance_data.client_add(null,null, null, 'https://res.cloudinary.com/dkzg5ez6i/image/upload/v1584312190/userProfile.jpg', user_id); END IF;
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.login(
    param_email VARCHAR
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
        SELECT 
            usr.id,
            usr.email,
            usr.password,
            usr.role_id,
			usr.isActive,
			usr.isDeleted,
            rol.name as role,
            COALESCE(cli.id, null) as client_id,
            COALESCE(cli.name, '') as name,
            COALESCE(cli.last_name, '') as last_name,
            COALESCE(cli.avatar, '') as avatar,
            COALESCE(cli.birth_date, null) as birth_date,
            cli.is_new
        FROM   
            per_finance_data.users usr
        INNER JOIN
            per_finance_data.roles rol 
        ON 
                usr.email = param_email
            AND
                rol.id = usr.role_id
        LEFT OUTER JOIN
            per_finance_data.clients cli
        ON
                cli.user_id = usr.id
            AND 
                cli.isDeleted = false
        WHERE
            usr.isDeleted = false
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.forgot_password(
    param_email VARCHAR
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
        SELECT
            id,
            email
        FROM
            per_finance_data.users usr
        WHERE
            usr.email = param_email
        AND
            usr.isActive = true
        AND 
            usr.isDeleted = false
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.change_password(
    param_id INT,
    param_password TEXT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.users
        SET
            password = param_password
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.update_user(
    param_id INT,
    param_email VARCHAR
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.users
        SET
            email = param_email
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;


CREATE OR REPLACE FUNCTION per_finance_data.is_active_user(
    param_id INT,
    param_is_active BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.users
        SET
            isActive = param_is_active
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_deleted_user(
    param_id INT,
    param_is_deleted BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.users
        SET
            isDeleted = param_is_deleted
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;



--functions of clients
CREATE OR REPLACE FUNCTION per_finance_data.client_add(
    param_name VARCHAR,
    param_last_name VARCHAR,
    param_birthdate DATE,
    param_avatar TEXT,
    param_userId INT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        IF EXISTS(
            SELECT 
                cli.name
            FROM 
                per_finance_data.clients cli
            WHERE
                cli.user_id = param_userId
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO
                per_finance_data.clients(name, last_name, birth_date, avatar, user_id)
            VALUES
                (param_name, param_last_name, param_birthdate, param_avatar, param_userId);

        END IF;
        local_is_successful :='1';
        return local_is_successful;
    END;
$udf$; 

CREATE OR REPLACE FUNCTION per_finance_data.get_client(
    param_id iNT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
        SELECT 
            cli.id,
			cli.user_id,
            COALESCE(cli.name, '') as name,
            COALESCE(cli.last_name, '') as last_name,
            COALESCE(cli.avatar, '') as avatar,
            COALESCE(cli.birth_date, null) as birth_date,
            usr.email
        FROM   
            per_finance_data.clients cli
        INNER JOIN
            per_finance_data.users usr
        ON
                cli.id = param_id
            AND
                cli.user_id = usr.id
            AND
                cli.isActive = true
            AND 
                cli.isDeleted = false
        WHERE
                usr.isActive = true
            AND 
                usr.isDeleted = false
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_clients()
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT 
            cli.id,
			cli.user_id,
            COALESCE(cli.name, '') as name,
            COALESCE(cli.last_name, '') as last_name,
            COALESCE(cli.avatar, '') as avatar,
            COALESCE(cli.birth_date, null) as birth_date,
            usr.email,
			cli.isActive,
			cli.isDeleted
        FROM   
            per_finance_data.clients cli
        INNER JOIN
            per_finance_data.users usr
        ON
            cli.user_id = usr.id
        ORDER BY
            cli.id
        ASC
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.update_client(
    param_id INT,
    param_name VARCHAR,
    param_last_name VARCHAR,
    param_avatar VARCHAR,
    param_birthdate DATE,
    param_userId INT,
    param_email VARCHAR
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.clients
        SET
            name = param_name,
            last_name = param_last_name,
            birth_date = param_birthdate,
            avatar = param_avatar,
            is_new = false
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            PERFORM per_finance_data.update_user(param_userId, param_email);
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_active_client(
    param_id INT,
    param_userId INT,
    param_is_active BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.clients
        SET
            isActive = param_is_active
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            PERFORM per_finance_data.is_active_user(param_userId, param_is_active);
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_deleted_client(
    param_id INT,
    param_userId INT,
    param_is_deleted BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.clients
        SET
            isDeleted = param_is_deleted
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            PERFORM per_finance_data.is_deleted_user(param_userId, param_is_deleted);
            local_is_successful := '1';
        END IF;
        return local_is_successful;
    END;
$udf$;


-- functions of currency
CREATE OR REPLACE FUNCTION per_finance_data.currency_add(
    param_name VARCHAR,
    param_code VARCHAR,
    param_symbol VARCHAR
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        IF EXISTS(
            select cur.name 
            from per_finance_data.currencies as cur
            WHERE
                    cur.name = param_name
                AND
                    cur.code = param_code
                AND
                    cur.symbol = param_symbol
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO
                per_finance_data.currencies(name, code, symbol)
            VALUES
                (param_name, param_code, param_symbol);
        
        END IF;
        local_is_successful :='1';
        return local_is_successful;
    END;
$udf$;


CREATE OR REPLACE FUNCTION per_finance_data.get_currency(
    param_currencyId INT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
        SELECT 
            cur.id,
            cur.name,
            cur.code,
            cur.symbol
        FROM   
            per_finance_data.currencies cur
        WHERE
                cur.id = param_currencyId
            AND
                cur.isActive = true
            AND 
                cur.isDeleted = false
    )DATA;
$BODY$;


CREATE OR REPLACE FUNCTION per_finance_data.get_currencies()
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
       SELECT 
            cur.id,
            cur.name,
            cur.code,
            cur.symbol,
			cur.isActive,
			cur.isDeleted
        FROM   
            per_finance_data.currencies cur
        ORDER BY
            cur.id
        ASC
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.update_currency(
    param_id INT,
    param_name VARCHAR,
    param_code VARCHAR,
    param_symbol VARCHAR
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE 
            per_finance_data.currencies
        SET
            name = param_name,
            code = param_code,
            symbol = param_symbol
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_active_currency(
    param_id INT,
    param_is_active BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE 
            per_finance_data.currencies
        SET
            isActive = param_is_active
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_deleted_currency(
    param_id INT,
    param_is_deleted BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE 
            per_finance_data.currencies
        SET
            isDeleted = param_is_deleted
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;


-- function of categories
CREATE OR REPLACE FUNCTION per_finance_data.category_add(
    param_name VARCHAR,
    param_description TEXT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        IF EXISTS(
            select cat.name 
            from per_finance_data.categories as cat
            WHERE
                cat.name = param_name
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO
                per_finance_data.categories(name, description)
            VALUES
                (param_name, param_description);
        
        END IF;
        local_is_successful :='1';
        return local_is_successful;
    END;
$udf$;


CREATE OR REPLACE FUNCTION per_finance_data.category_add_personal(
    param_name VARCHAR,
    param_description TEXT,
    param_userId INT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        IF EXISTS(
            select cat.name 
            from per_finance_data.categories as cat
            WHERE
                    cat.name = param_name
                AND
                    cat.user_id = param_userId
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO
                per_finance_data.categories(name, description, is_personal, user_id)
            VALUES
                (param_name, param_description, true, param_userId);
        
        END IF;
        local_is_successful :='1';
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.get_category(
    param_id INT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
        SELECT
            cat.id,
            cat.name as category,
            cat.description,
            COALESCE(cat.is_personal, false) as is_personal
        FROM
            per_finance_data.categories cat
        LEFT OUTER JOIN
            per_finance_data.users usr
        ON
                usr.id = cat.user_id
            AND
                usr.isActive = true
            AND
                usr.isDeleted = false
        LEFT OUTER JOIN
            per_finance_data.clients cli
        ON
                cli.user_id =  usr.id
            AND
                cli.isActive = true
            AND
                cli.isDeleted = false
            
        WHERE
				cat.id = param_id
			AND
                cat.isActive = true
            AND
                cat.isDeleted = false
    )DATA;
$BODY$;


CREATE OR REPLACE FUNCTION per_finance_data.get_Categories_global()
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            cat.id,
            cat.name,
            cat.description,
			cat.isActive,
			cat.isDeleted
        FROM
            per_finance_data.categories cat
        WHERE
			cat.user_id IS NULL
        ORDER BY
            cat.id
        ASC
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_Categories_include_personal(
    param_userId INT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
       SELECT
            cat.id,
            cat.name,
            cat.description,
			COALESCE(cat.is_personal, false) as is_personal,
			cat.isActive
        FROM
            per_finance_data.categories cat
        WHERE
                (
					(
							cat.isActive = true
						AND
							cat.user_id IS NULL
					)
				OR
					(
							cat.user_id = param_userId
					)
				)
            AND
                cat.isDeleted = false
        ORDER BY
            cat.id
        ASC
    )DATA;
$BODY$;


CREATE OR REPLACE FUNCTION per_finance_data.update_category(
    param_id INT,
    param_name VARCHAR,
    param_description TEXT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.categories
        SET
            name = param_name,
            description = param_description
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_active_category(
    param_id INT,
    param_is_active BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.categories
        SET
            isActive = param_is_active
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.is_deleted_category(
    param_id INT,
    param_is_deleted BOOLEAN
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.categories
        SET
            isDeleted = param_is_deleted
        WHERE
            id = param_id;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.delete_category_personal(
    param_id INT,
    param_userId INT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        DELETE FROM 
            per_finance_data.categories 
        WHERE
                id = param_id
            AND
                user_id = param_userId
            AND
                is_personal = true;
        
        local_is_successful := '1';
        return local_is_successful;
    END;
$udf$;


-- functions of finance

CREATE OR REPLACE FUNCTION per_finance_data.finance_add(
    param_title VARCHAR,
    param_description TEXT,
    param_mount double precision,
    param_finance_date DATE,
    param_finance_hour TIME,
    param_categoryId INTEGER,
    param_currencyId INTEGER,
    param_isIncome BOOLEAN,
    param_userId INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        IF EXISTS(
            select fin.title
            from per_finance_data.finance as fin
            WHERE
                    fin.title = param_title
                AND
                    fin.is_income = param_isIncome
                AND
                    fin.category_id = param_categoryId
                AND
                    fin.finance_date = param_finance_date
                AND
                    fin.finance_hour = param_finance_hour
                AND 
                    fin.mount = param_mount
                AND
                    fin.user_id = param_userId
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO
                per_finance_data.finance(title,description,mount, finance_date, finance_hour, category_id, currency_id, is_income, user_id)
            VALUES
                (param_title, param_description, param_mount, param_finance_date, param_finance_hour, param_categoryId, param_currencyId, param_isIncome, param_userId);
        END IF;
        local_is_successful :='1';
        return local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.get_finance(
    param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
        SELECT
            fin.id,
            fin.title,
            fin.description,
            fin.mount,
            fin.finance_date,
            fin.finance_hour,
            fin.is_income,
            fin.currency_id,
            fin.category_id,
            fin.user_id,
            cat.name as category,
            cur.name as currency          
        FROM
            per_finance_data.finance fin
        INNER JOIN
            per_finance_data.categories cat
        ON
                fin.category_id = cat.id
            AND
                cat.isActive = true
            AND
                cat.isDeleted = false
            INNER JOIN
                per_finance_data.currencies cur
            ON
                 fin.currency_id = cur.id
            AND
                cur.isActive = true
            AND
                cur.isDeleted = false
            INNER JOIN
                per_finance_data.users usr
            ON
                fin.user_id = usr.id
            AND
                usr.isActive = true
            AND
                usr.isDeleted = false
            WHERE
                 fin.id = param_id
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_finance_balance(
    param_userId INTEGER
)
RETURNS json
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        income_json JSON;
        expense_json JSON;
        income_total double precision := 0;
        expense_total double precision := 0;
    BEGIN
        SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(INCOME))) INTO income_json
        FROM (
            SELECT DISTINCT
            fin.id,
            fin.title,
            fin.mount,
            fin.finance_date,
            fin.finance_hour,
            cat.name as category,
            cur.name as currency          
        FROM
            per_finance_data.finance fin
        INNER JOIN
            per_finance_data.categories cat
        ON
                fin.is_income = true
            AND
                fin.category_id = cat.id
            AND
                cat.isActive = true
            AND
                cat.isDeleted = false
            INNER JOIN
                per_finance_data.currencies cur
            ON
                 fin.currency_id = cur.id
            AND
                cur.isActive = true
            AND
                cur.isDeleted = false
            INNER JOIN
                per_finance_data.users usr
            ON
                fin.user_id = param_userId
            AND
                usr.isActive = true
            AND
                usr.isDeleted = false
        ORDER BY
            fin.finance_date DESC, 
            fin.finance_hour DESC
            LIMIT 5
        )INCOME;

        SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(EXPENSE))) INTO expense_json
        FROM (
            SELECT DISTINCT
            fin.id,
            fin.title,
            fin.mount,
            fin.finance_date,
            fin.finance_hour,
            cat.name as category,
            cur.name as currency             
        FROM
            per_finance_data.finance fin
        INNER JOIN
            per_finance_data.categories cat
        ON
                fin.is_income = false
            AND
                fin.category_id = cat.id
            AND
                cat.isActive = true
            AND
                cat.isDeleted = false
            INNER JOIN
                per_finance_data.currencies cur
            ON
                 fin.currency_id = cur.id
            AND
                cur.isActive = true
            AND
                cur.isDeleted = false
            INNER JOIN
                per_finance_data.users usr
            ON
                fin.user_id = param_userId
            AND
                usr.isActive = true
            AND
                usr.isDeleted = false
        ORDER BY
            fin.finance_date DESC, 
            fin.finance_hour DESC
        LIMIT 5
        )EXPENSE;

        SELECT 
            SUM(mount) INTO income_total
        FROM
            per_finance_data.finance
        WHERE 
            is_income = true;

        SELECT 
            SUM(mount) INTO expense_total
        FROM
            per_finance_data.finance
        WHERE 
            is_income = false;
        
        return json_build_object('income_total', income_total, 'expense_total', expense_total, 'income', income_json, 'expense', expense_json, 'balance_total', income_total-expense_total);
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.get_expense_category_month(
    param_userId INTEGER,
    param_month INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM(
        SELECT 
            cat.name as category,
            SUM(fin.mount) as mount_total
        FROM
            per_finance_data.finance fin
        INNER JOIN 
            per_finance_data.categories cat
        ON
	        cat.id = fin.category_id
	    AND
	        cat.isActive = true
	    AND
	        cat.isDeleted = false
	    WHERE
	        fin.user_id = param_userId
	    AND
	        EXTRACT(MONTH FROM fin.finance_date) = param_month
	    AND
	        fin.is_income = false
	    GROUP BY 
            category
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_expense_month_year(
    param_userId INTEGER,
    param_year INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM(
        SELECT
            EXTRACT(MONTH FROM finance_date) as month_finance,
            SUM(mount) as expense_total
        FROM 
            per_finance_data.finance
        WHERE
            user_id = param_userId
        AND
            is_income = false
        AND
            EXTRACT(YEAR FROM finance_date) = param_year
        GROUP BY 
            month_finance
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_expense_progression(
    param_userId INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM(
        SELECT
            finance_date,
            mount
        FROM
            per_finance_data.finance
        WHERE
            user_id = param_userId
        AND
            is_income = false
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_expense_day_month(
    param_userId INTEGER,
    param_month INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM(
        SELECT
            EXTRACT(DAY FROM finance_date) as day_finance,
            SUM(mount) as expense_total
        FROM 
            per_finance_data.finance
        WHERE
            user_id = param_userId
        AND
            is_income = false
        AND
            EXTRACT(MONTH FROM finance_date) = param_month
        GROUP BY 
            day_finance
    )DATA;
$BODY$;


CREATE OR REPLACE FUNCTION per_finance_data.get_month_expense(
    param_userId INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM(
        SELECT DISTINCT
            EXTRACT(MONTH FROM finance_date) as month_finance
        FROM 
            per_finance_data.finance
        WHERE
            user_id = param_userId
        AND
            is_income = false
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_year_expense(
    param_userId INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM(
        SELECT DISTINCT
            EXTRACT(YEAR FROM finance_date) as year_finance
        FROM 
            per_finance_data.finance
        WHERE
            user_id = param_userId
        AND
            is_income = false
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION per_finance_data.get_finance_list(
    param_userId INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT DISTINCT
            fin.id,
            fin.title,
            fin.description,
            fin.mount,
            fin.finance_date,
            fin.finance_hour,
            fin.is_income,
            fin.currency_id,
            fin.category_id,
            fin.user_id,
            cat.name as category,
            cur.name as currency          
        FROM
            per_finance_data.finance fin
        INNER JOIN
            per_finance_data.categories cat
        ON
                fin.category_id = cat.id
            AND
                cat.isActive = true
            AND
                cat.isDeleted = false
            INNER JOIN
                per_finance_data.currencies cur
            ON
                 fin.currency_id = cur.id
            AND
                cur.isActive = true
            AND
                cur.isDeleted = false
            INNER JOIN
                per_finance_data.users usr
            ON
                fin.user_id = param_userId
            AND
                usr.isActive = true
            AND
                usr.isDeleted = false
        ORDER BY
            fin.finance_date DESC, 
            fin.finance_hour DESC
    )DATA;
$BODY$;


CREATE OR REPLACE FUNCTION per_finance_data.update_finance(
    param_id INTEGER,
    param_title VARCHAR,
    param_description TEXT,
    param_mount double precision,
    param_finance_date DATE,
    param_finance_hour TIME,
    param_categoryId INTEGER,
    param_currencyId INTEGER,
    param_isIncome BOOLEAN,
    param_userId INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        updated_rows INTEGER := 0;
    BEGIN
        UPDATE
            per_finance_data.finance
        SET
            title = param_title,
            description = param_description,
            mount = param_mount,
            finance_date = param_finance_date,
            finance_hour = param_finance_hour,
            category_id = param_categoryId,
            currency_id = param_currencyId,
            is_income = param_isIncome
        WHERE
                id = param_id
            AND
                user_id = param_userId;
        GET DIAGNOSTICS updated_rows = ROW_COUNT;

        IF updated_rows != 0 THEN
            local_is_successful := '1';
        END IF;
        RETURN local_is_successful;
    END;
$udf$;

CREATE OR REPLACE FUNCTION per_finance_data.delete_finance(
    param_id INTEGER,
    param_userId INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        DELETE FROM 
            per_finance_data.finance 
        WHERE
                id = param_id
            AND
                user_id = param_userId;

        local_is_successful := '1';
        return local_is_successful;
    END;
$udf$;