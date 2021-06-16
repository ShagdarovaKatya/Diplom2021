PGDMP         *                 y            postgres    9.5.24    9.6.20 Q    �
           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �
           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �
           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    17            �
           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    17            �           1247    115293 
   genderenum    TYPE     D   CREATE TYPE public.genderenum AS ENUM (
    'male',
    'female'
);
    DROP TYPE public.genderenum;
       public       postgres    false    17            N           1255    19349 &   create_group(text, text, uuid, text[])    FUNCTION     �  CREATE FUNCTION public.create_group(p_name text, p_system_id text, p_uuid uuid, p_group_uids_and_system_ids text[] DEFAULT ARRAY[]::text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
  v_uuid uuid;
BEGIN
  p_name = regexp_replace(p_name, E'[\\n\\r]+', ' ', 'g' );
 
  SELECT principal_uid INTO v_uuid FROM core.principals WHERE (name = p_name AND type='GROUP') OR principal_uid = p_uuid;

  IF NOT FOUND THEN
    INSERT INTO core.principals (name, type, principal_uid, system_id)
    VALUES (p_name, 'GROUP', p_uuid, p_system_id);
	
	v_uuid = p_uuid;
  END IF;

  PERFORM make_member_of(v_uuid, p_group_uids_and_system_ids::text[]);
END;
$$;
 s   DROP FUNCTION public.create_group(p_name text, p_system_id text, p_uuid uuid, p_group_uids_and_system_ids text[]);
       public       postgres    false    17            O           1255    19350 .   create_user(text, text, uuid, boolean, text[])    FUNCTION     {  CREATE FUNCTION public.create_user(p_name text, p_password text, p_uuid uuid, p_enabled boolean, p_member_of_name text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO core.principals (name, type, principal_uid, user_password, user_enabled)
  VALUES (p_name, 'USER', p_uuid, p_password, p_enabled);

  PERFORM make_member_of(p_uuid, p_member_of_name);
END;
$$;
 y   DROP FUNCTION public.create_user(p_name text, p_password text, p_uuid uuid, p_enabled boolean, p_member_of_name text[]);
       public       postgres    false    17            P           1255    19351    cyrillic_transliterate(text)    FUNCTION     �  CREATE FUNCTION public.cyrillic_transliterate(p_string text) RETURNS character varying
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT replace(replace(replace(replace(replace( replace( replace( replace(translate(lower($1),
  'абвгдеёзийклмнопрстуфхцэы', 'abvgdeezijklmnoprstufxcey'), 'ж', 'zh'),
  'ч', 'ch'), 'ш', 'sh'), 'щ', 'shh'), 'ъ', ''), 'ю', 'yu'), 'я', 'ya'), 'ь', '');
$_$;
 <   DROP FUNCTION public.cyrillic_transliterate(p_string text);
       public       postgres    false    17            Q           1255    19352    make_member_of(uuid, text[])    FUNCTION     �  CREATE FUNCTION public.make_member_of(p_uuid uuid, p_group_uids_and_system_ids_and_names text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_found_uids uuid[];
  v_found_system_ids text[];
  v_found_names text[];
  v_not_found text[];
BEGIN
  SELECT
    array_agg(principal_uid),
    array_agg(system_id),
    array_agg(name)
  INTO v_found_uids, v_found_system_ids, v_found_names
  FROM core.principals
  WHERE principal_uid::text = ANY(p_group_uids_and_system_ids_and_names)
    OR system_id = ANY(p_group_uids_and_system_ids_and_names)
    OR name = ANY(p_group_uids_and_system_ids_and_names);

  v_not_found = array(
    SELECT unnest(p_group_uids_and_system_ids_and_names)
    EXCEPT SELECT unnest(v_found_system_ids)
    EXCEPT SELECT unnest(v_found_uids::text[])
    EXCEPT SELECT unnest(v_found_names::text[]));

  IF array_length(v_not_found, 1) != 0 THEN
    RAISE EXCEPTION 'Unknown roles or groups: %', v_not_found;
  END IF;

  INSERT INTO core.group_membership (member_uid, group_uid)
    SELECT p_uuid, *
    FROM unnest(v_found_uids) v
    WHERE NOT EXISTS(
      SELECT *
      FROM core.group_membership gm
      WHERE gm.member_uid = v
      AND gm.member_uid = p_uuid
    )
  ON CONFLICT DO NOTHING;
END;
$$;
 `   DROP FUNCTION public.make_member_of(p_uuid uuid, p_group_uids_and_system_ids_and_names text[]);
       public       postgres    false    17            �           3600    20883 
   simple_eng    TEXT SEARCH DICTIONARY     q   CREATE TEXT SEARCH DICTIONARY public.simple_eng (
    TEMPLATE = pg_catalog.simple,
    stopwords = 'english' );
 /   DROP TEXT SEARCH DICTIONARY public.simple_eng;
       public       postgres    false    17            �           3600    20884 
   simple_rus    TEXT SEARCH DICTIONARY     q   CREATE TEXT SEARCH DICTIONARY public.simple_rus (
    TEMPLATE = pg_catalog.simple,
    stopwords = 'russian' );
 /   DROP TEXT SEARCH DICTIONARY public.simple_rus;
       public       postgres    false    17            �           3602    20885 
   invest_rus    TEXT SEARCH CONFIGURATION     �  CREATE TEXT SEARCH CONFIGURATION public.invest_rus (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR asciiword WITH public.simple_eng;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR word WITH public.simple_rus;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR hword_part WITH public.simple_rus;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR hword_asciipart WITH public.simple_eng;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR asciihword WITH public.simple_eng;

ALTER TEXT SEARCH CONFIGURATION public.invest_rus
    ADD MAPPING FOR hword WITH public.simple_rus;
 2   DROP TEXT SEARCH CONFIGURATION public.invest_rus;
       public       postgres    false    17    2222    2223            �           3602    20886 
   simple_rus    TEXT SEARCH CONFIGURATION     q  CREATE TEXT SEARCH CONFIGURATION public.simple_rus (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR asciiword WITH public.simple_eng;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR word WITH public.simple_rus;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR hword_part WITH public.simple_rus;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR hword_asciipart WITH public.simple_eng;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR asciihword WITH public.simple_eng;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR hword WITH public.simple_rus;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.simple_rus
    ADD MAPPING FOR uint WITH simple;
 2   DROP TEXT SEARCH CONFIGURATION public.simple_rus;
       public       postgres    false    2223    2222    17            �            1259    115398    Configs    TABLE     c   CREATE TABLE public."Configs" (
    id integer NOT NULL,
    name text NOT NULL,
    value text
);
    DROP TABLE public."Configs";
       public         postgres    false    17            �            1259    115396    Configs_id_seq    SEQUENCE     y   CREATE SEQUENCE public."Configs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."Configs_id_seq";
       public       postgres    false    205    17            �
           0    0    Configs_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."Configs_id_seq" OWNED BY public."Configs".id;
            public       postgres    false    204            �            1259    115283    Departments    TABLE     W   CREATE TABLE public."Departments" (
    id integer NOT NULL,
    name text NOT NULL
);
 !   DROP TABLE public."Departments";
       public         postgres    false    17            �            1259    115281    Departments_id_seq    SEQUENCE     }   CREATE SEQUENCE public."Departments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."Departments_id_seq";
       public       postgres    false    17    193            �
           0    0    Departments_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."Departments_id_seq" OWNED BY public."Departments".id;
            public       postgres    false    192            �            1259    115332    Examinations    TABLE       CREATE TABLE public."Examinations" (
    id integer NOT NULL,
    "patientId" integer NOT NULL,
    "examinationDate" timestamp without time zone NOT NULL,
    name character varying,
    contents text,
    "physicianId" integer,
    comments text,
    tags text,
    deleted boolean
);
 "   DROP TABLE public."Examinations";
       public         postgres    false    17            �            1259    115330    Examinations_id_seq    SEQUENCE     ~   CREATE SEQUENCE public."Examinations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."Examinations_id_seq";
       public       postgres    false    17    201            �
           0    0    Examinations_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."Examinations_id_seq" OWNED BY public."Examinations".id;
            public       postgres    false    200            �            1259    115598 
   InPatients    TABLE       CREATE TABLE public."InPatients" (
    id integer NOT NULL,
    "patientId" integer NOT NULL,
    "departmentId" integer,
    "roomId" integer,
    admission text,
    orders text,
    problems text,
    "physicianId" integer,
    discharged boolean,
    status text
);
     DROP TABLE public."InPatients";
       public         postgres    false    17            �            1259    115596    InPatients_id_seq    SEQUENCE     |   CREATE SEQUENCE public."InPatients_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."InPatients_id_seq";
       public       postgres    false    208    17            �
           0    0    InPatients_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."InPatients_id_seq" OWNED BY public."InPatients".id;
            public       postgres    false    207            �            1259    115299    Patients    TABLE     K  CREATE TABLE public."Patients" (
    id integer NOT NULL,
    family text NOT NULL,
    name text NOT NULL,
    "thirdName" text,
    value public.genderenum NOT NULL,
    birthdate timestamp without time zone NOT NULL,
    address text,
    phone text,
    diagnosos text,
    tags text,
    comments text,
    deleted boolean
);
    DROP TABLE public."Patients";
       public         postgres    false    1003    17            �            1259    115297    Patients_id_seq    SEQUENCE     z   CREATE SEQUENCE public."Patients_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Patients_id_seq";
       public       postgres    false    17    195            �
           0    0    Patients_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Patients_id_seq" OWNED BY public."Patients".id;
            public       postgres    false    194            �            1259    115310 
   Physicians    TABLE     �   CREATE TABLE public."Physicians" (
    id integer NOT NULL,
    name text NOT NULL,
    family text NOT NULL,
    "thirdName" text
);
     DROP TABLE public."Physicians";
       public         postgres    false    17            �            1259    115308    Physicians_id_seq    SEQUENCE     |   CREATE SEQUENCE public."Physicians_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."Physicians_id_seq";
       public       postgres    false    197    17            �
           0    0    Physicians_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."Physicians_id_seq" OWNED BY public."Physicians".id;
            public       postgres    false    196            �            1259    115374    Rooms    TABLE     m   CREATE TABLE public."Rooms" (
    id integer NOT NULL,
    name text NOT NULL,
    "departmentId" integer
);
    DROP TABLE public."Rooms";
       public         postgres    false    17            �            1259    115372    Rooms_id_seq    SEQUENCE     w   CREATE SEQUENCE public."Rooms_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Rooms_id_seq";
       public       postgres    false    203    17            �
           0    0    Rooms_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Rooms_id_seq" OWNED BY public."Rooms".id;
            public       postgres    false    202            �            1259    115321 	   Templates    TABLE     �   CREATE TABLE public."Templates" (
    id integer NOT NULL,
    name text NOT NULL,
    content text,
    html text,
    comments text
);
    DROP TABLE public."Templates";
       public         postgres    false    17            �            1259    115319    Templates_id_seq    SEQUENCE     {   CREATE SEQUENCE public."Templates_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Templates_id_seq";
       public       postgres    false    199    17            �
           0    0    Templates_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Templates_id_seq" OWNED BY public."Templates".id;
            public       postgres    false    198            �            1259    115450    alembic_version    TABLE     X   CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE public.alembic_version;
       public         postgres    false    17            O
           2604    115401 
   Configs id    DEFAULT     l   ALTER TABLE ONLY public."Configs" ALTER COLUMN id SET DEFAULT nextval('public."Configs_id_seq"'::regclass);
 ;   ALTER TABLE public."Configs" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    205    204    205            I
           2604    115286    Departments id    DEFAULT     t   ALTER TABLE ONLY public."Departments" ALTER COLUMN id SET DEFAULT nextval('public."Departments_id_seq"'::regclass);
 ?   ALTER TABLE public."Departments" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    193    192    193            M
           2604    115335    Examinations id    DEFAULT     v   ALTER TABLE ONLY public."Examinations" ALTER COLUMN id SET DEFAULT nextval('public."Examinations_id_seq"'::regclass);
 @   ALTER TABLE public."Examinations" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    201    200    201            P
           2604    115601    InPatients id    DEFAULT     r   ALTER TABLE ONLY public."InPatients" ALTER COLUMN id SET DEFAULT nextval('public."InPatients_id_seq"'::regclass);
 >   ALTER TABLE public."InPatients" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    207    208    208            J
           2604    115302    Patients id    DEFAULT     n   ALTER TABLE ONLY public."Patients" ALTER COLUMN id SET DEFAULT nextval('public."Patients_id_seq"'::regclass);
 <   ALTER TABLE public."Patients" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    195    194    195            K
           2604    115313    Physicians id    DEFAULT     r   ALTER TABLE ONLY public."Physicians" ALTER COLUMN id SET DEFAULT nextval('public."Physicians_id_seq"'::regclass);
 >   ALTER TABLE public."Physicians" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    197    196    197            N
           2604    115377    Rooms id    DEFAULT     h   ALTER TABLE ONLY public."Rooms" ALTER COLUMN id SET DEFAULT nextval('public."Rooms_id_seq"'::regclass);
 9   ALTER TABLE public."Rooms" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    203    202    203            L
           2604    115324    Templates id    DEFAULT     p   ALTER TABLE ONLY public."Templates" ALTER COLUMN id SET DEFAULT nextval('public."Templates_id_seq"'::regclass);
 =   ALTER TABLE public."Templates" ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    199    198    199            �
          0    115398    Configs 
   TABLE DATA               4   COPY public."Configs" (id, name, value) FROM stdin;
    public       postgres    false    205            �
           0    0    Configs_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."Configs_id_seq"', 2, true);
            public       postgres    false    204            �
          0    115283    Departments 
   TABLE DATA               1   COPY public."Departments" (id, name) FROM stdin;
    public       postgres    false    193            �
           0    0    Departments_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."Departments_id_seq"', 6, true);
            public       postgres    false    192            �
          0    115332    Examinations 
   TABLE DATA               �   COPY public."Examinations" (id, "patientId", "examinationDate", name, contents, "physicianId", comments, tags, deleted) FROM stdin;
    public       postgres    false    201            �
           0    0    Examinations_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."Examinations_id_seq"', 29, true);
            public       postgres    false    200            �
          0    115598 
   InPatients 
   TABLE DATA               �   COPY public."InPatients" (id, "patientId", "departmentId", "roomId", admission, orders, problems, "physicianId", discharged, status) FROM stdin;
    public       postgres    false    208            �
           0    0    InPatients_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."InPatients_id_seq"', 9, true);
            public       postgres    false    207            �
          0    115299    Patients 
   TABLE DATA               �   COPY public."Patients" (id, family, name, "thirdName", value, birthdate, address, phone, diagnosos, tags, comments, deleted) FROM stdin;
    public       postgres    false    195                        0    0    Patients_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Patients_id_seq"', 36, true);
            public       postgres    false    194            �
          0    115310 
   Physicians 
   TABLE DATA               E   COPY public."Physicians" (id, name, family, "thirdName") FROM stdin;
    public       postgres    false    197                       0    0    Physicians_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."Physicians_id_seq"', 16, true);
            public       postgres    false    196            �
          0    115374    Rooms 
   TABLE DATA               ;   COPY public."Rooms" (id, name, "departmentId") FROM stdin;
    public       postgres    false    203                       0    0    Rooms_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public."Rooms_id_seq"', 4, true);
            public       postgres    false    202            �
          0    115321 	   Templates 
   TABLE DATA               H   COPY public."Templates" (id, name, content, html, comments) FROM stdin;
    public       postgres    false    199                       0    0    Templates_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Templates_id_seq"', 6, true);
            public       postgres    false    198            �
          0    115450    alembic_version 
   TABLE DATA               6   COPY public.alembic_version (version_num) FROM stdin;
    public       postgres    false    206            `
           2606    115454 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public         postgres    false    206    206            ^
           2606    115406    Configs pk_Configs 
   CONSTRAINT     T   ALTER TABLE ONLY public."Configs"
    ADD CONSTRAINT "pk_Configs" PRIMARY KEY (id);
 @   ALTER TABLE ONLY public."Configs" DROP CONSTRAINT "pk_Configs";
       public         postgres    false    205    205            R
           2606    115291    Departments pk_Departments 
   CONSTRAINT     \   ALTER TABLE ONLY public."Departments"
    ADD CONSTRAINT "pk_Departments" PRIMARY KEY (id);
 H   ALTER TABLE ONLY public."Departments" DROP CONSTRAINT "pk_Departments";
       public         postgres    false    193    193            Z
           2606    115340    Examinations pk_Examinations 
   CONSTRAINT     ^   ALTER TABLE ONLY public."Examinations"
    ADD CONSTRAINT "pk_Examinations" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."Examinations" DROP CONSTRAINT "pk_Examinations";
       public         postgres    false    201    201            b
           2606    115606    InPatients pk_InPatients 
   CONSTRAINT     Z   ALTER TABLE ONLY public."InPatients"
    ADD CONSTRAINT "pk_InPatients" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."InPatients" DROP CONSTRAINT "pk_InPatients";
       public         postgres    false    208    208            T
           2606    115307    Patients pk_Patients 
   CONSTRAINT     V   ALTER TABLE ONLY public."Patients"
    ADD CONSTRAINT "pk_Patients" PRIMARY KEY (id);
 B   ALTER TABLE ONLY public."Patients" DROP CONSTRAINT "pk_Patients";
       public         postgres    false    195    195            V
           2606    115318    Physicians pk_Physicians 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Physicians"
    ADD CONSTRAINT "pk_Physicians" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."Physicians" DROP CONSTRAINT "pk_Physicians";
       public         postgres    false    197    197            \
           2606    115382    Rooms pk_Rooms 
   CONSTRAINT     P   ALTER TABLE ONLY public."Rooms"
    ADD CONSTRAINT "pk_Rooms" PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."Rooms" DROP CONSTRAINT "pk_Rooms";
       public         postgres    false    203    203            X
           2606    115329    Templates pk_Templates 
   CONSTRAINT     X   ALTER TABLE ONLY public."Templates"
    ADD CONSTRAINT "pk_Templates" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Templates" DROP CONSTRAINT "pk_Templates";
       public         postgres    false    199    199            c
           2606    115341 /   Examinations fk_Examinations_patientId_Patients    FK CONSTRAINT     �   ALTER TABLE ONLY public."Examinations"
    ADD CONSTRAINT "fk_Examinations_patientId_Patients" FOREIGN KEY ("patientId") REFERENCES public."Patients"(id);
 ]   ALTER TABLE ONLY public."Examinations" DROP CONSTRAINT "fk_Examinations_patientId_Patients";
       public       postgres    false    2644    201    195            d
           2606    115346 3   Examinations fk_Examinations_physicianId_Physicians    FK CONSTRAINT     �   ALTER TABLE ONLY public."Examinations"
    ADD CONSTRAINT "fk_Examinations_physicianId_Physicians" FOREIGN KEY ("physicianId") REFERENCES public."Physicians"(id);
 a   ALTER TABLE ONLY public."Examinations" DROP CONSTRAINT "fk_Examinations_physicianId_Physicians";
       public       postgres    false    2646    201    197            f
           2606    115607 1   InPatients fk_InPatients_departmentId_Departments    FK CONSTRAINT     �   ALTER TABLE ONLY public."InPatients"
    ADD CONSTRAINT "fk_InPatients_departmentId_Departments" FOREIGN KEY ("departmentId") REFERENCES public."Departments"(id);
 _   ALTER TABLE ONLY public."InPatients" DROP CONSTRAINT "fk_InPatients_departmentId_Departments";
       public       postgres    false    208    2642    193            g
           2606    115617 +   InPatients fk_InPatients_patientId_Patients    FK CONSTRAINT     �   ALTER TABLE ONLY public."InPatients"
    ADD CONSTRAINT "fk_InPatients_patientId_Patients" FOREIGN KEY ("patientId") REFERENCES public."Patients"(id);
 Y   ALTER TABLE ONLY public."InPatients" DROP CONSTRAINT "fk_InPatients_patientId_Patients";
       public       postgres    false    2644    208    195            h
           2606    115622 /   InPatients fk_InPatients_physicianId_Physicians    FK CONSTRAINT     �   ALTER TABLE ONLY public."InPatients"
    ADD CONSTRAINT "fk_InPatients_physicianId_Physicians" FOREIGN KEY ("physicianId") REFERENCES public."Physicians"(id);
 ]   ALTER TABLE ONLY public."InPatients" DROP CONSTRAINT "fk_InPatients_physicianId_Physicians";
       public       postgres    false    197    2646    208            i
           2606    115627 %   InPatients fk_InPatients_roomId_Rooms    FK CONSTRAINT     �   ALTER TABLE ONLY public."InPatients"
    ADD CONSTRAINT "fk_InPatients_roomId_Rooms" FOREIGN KEY ("roomId") REFERENCES public."Rooms"(id);
 S   ALTER TABLE ONLY public."InPatients" DROP CONSTRAINT "fk_InPatients_roomId_Rooms";
       public       postgres    false    203    208    2652            e
           2606    115383 &   Rooms fk_Rooms_depatmentId_Departments    FK CONSTRAINT     �   ALTER TABLE ONLY public."Rooms"
    ADD CONSTRAINT "fk_Rooms_depatmentId_Departments" FOREIGN KEY ("departmentId") REFERENCES public."Departments"(id);
 T   ALTER TABLE ONLY public."Rooms" DROP CONSTRAINT "fk_Rooms_depatmentId_Departments";
       public       postgres    false    193    203    2642            �
   8   x�3�L����L�K�M�,I-.qs�S�ML�����))E���H
�"FF\1z\\\ |��      �
   2   x�3�,I-.1�2�&\Ɯi�\&��Y�\��)�i�)i\fW� [90      �
   m  x��W[n�@�V1�cj����K.��8 �4����G��Trn�-��BW�s��!��P$^�;�̹�\,0�(�q����͡v�cy�0��P��O�2�
�A7���j��(�(�U�hJ9ev`O)��vH�}O�����G��%��%ޘ-	_�����K��
�:�� p�T��=��>M(��1>E�Lh���j�u��};�L�i����������v=M)�v��uz�L9D�"3��v�@6�)�X�\ؘ���XQC���ѩ�ƲF=�>�F`oNwo;!8%+����U�9�[���/.h�raɂ-�#p͸ -��]BJD3;xL��3-vHN�-P� �W=R\#�v��\��Vt&�HaJ	���18�x x���T������yz)�L|�A��^e���Hz��ġ2Y$���Y"_���R
��Z����C1�*ָkr����C�
�i;�#�b�yj��[,>3[����!EO1�Ky�=�U�`D"��1���C5�jj�:�T�.zo}��kG��?�����=��^p���p���r"��O�(^��֫�ۻh����:��]آě�즹)σ��*D\+����k0���_Uq�)T�8�i�j�?�=+      �
   �   x�3�4�4�?*\F�$L��@�!a�K�(h��0�����TH
$��0K��!�q��v�6\�~a��/l�;.�_��t�����4N ( !/lJ)N3��;F��� ��O�      �
     x���Aj�0E��)z��[��=DO0�cgѮ<���H:t�(�$��.��2�dJy��w���z?��{�7c>j������m.�C{�M�����Pk��
1�GyBi=R��ֿ�7c��aȠ5 Ȥ�
h8���c��Xh8��x*� ^-!���D���-���f��;!�t#�"�b���~EN�H_�\���tFi��PGb�a��G��s�95�;���=�:��I�pR?�˩ʿ��Sy� ����F7ЯDJ1���D��w]�nq�T      �
   A   x�3�,I-.)Ȩ,6����,c.C#����b0�Y���eh̙�����,/L-�24A����� 3��      �
   0   x�3�,I-.)2�4�2�0�8����̒"��	gzV���	W� $�	      �
      x��][oǕ~�E��$u�lm�d7�>�����i�Λ_x��Zɢ������G�������!�d�\��ԭ/3Cٱ���9�S]u�ԩs�sۻ������{��>�����>���k]�䝛ךϛ�j���l�D���O���U7'���w��Es��,�E���Ǫj��S�(����U�j�J5�Q�ݿw�S��z�<ѿ�
�������v����B��w�W��w�����L͊�9�������-���<m>�_�����B]�Ŷ��I��S��X<׫9�o9*�_ͱ��#\�\͛����ŕj��]5�a��N������=�ͻ�C�g�9�/��3����Y�T��`�[=�,�>�+�S�����58/��E���M�XU��V��}��8@����{�.qL����6���V�"��%L����R��D?5�OMz,�gP����
�P��.qbw�]�N䪆.x�
�`��v�<���\Ùj����c�jn�ؔ7e���
��ĝ�+�􂾠}��ݜ�2iwt�̾����O߳{��y/�_�zE��L_��Ul�Z��9�5��׃��b���6����y�y���� ;FÊ#^�9
Y-������KX�́f�<��\�WW���83��f :-z�)H����{��Q�G+p�$�H�G|���r�t��Fx�Ң*��x��%���]V����i�n���|S���5�1'qSn���`�5�`�}A{j�霈7��G�O����Y ��ˇ{y��j�?B�/x
'ZƅBu�A��սƽ:������<-`"��7�#|5̤�t֣�C��'�����=��7"�
3sY�ԣsS����c�}g0\���/�+jZ�������q2���~sӇ��т��3��p`Xj<�:�)G�?g�n?q�9j�s�t�\�xKÀ�>��	���<�.	�E��B��j�"N���Z�pN���<-���L]�$?U����<)�S\Ė>�%��)�G҂��y�?�;ּ�;%�?�>L9^0���ʑ=#����ƖMQ�B�<��Y��M�y؂dc	�mh��	�t}�j�!��5a=��w7���_��I�[:'�A�Ϸ�@+z~F�(�jn4kҾ�)����ޘ�ƹpwo����{�tA�8���.�
�ӚF?�1�5leDĲs#��o߂�ܢ;���*#��@�W��D�B
��J�dAG�m�t��JM7��Z�'5GAb�$}m�;��p��6#�E�k~���D���W�t[�V��e_8��b�®!%`x���C�/��nT0�@b����8�گ�^G�A�
;dT�S���SLꊍ6���3ӂ�yaT���.����E���	�<�B�4�z��C+֯@���\���������Ф%HE��g֨I��t���=���v0�#�wA8����_ZD�\e�������t�H�B�؜����yW.��6I�?Ԥ��o�ȑ�t�{�'^Ӊe�1#�A<��ʨ��`cN񪅅���%.f!���3{$t�����яID����rA�P�X��G��k7�4�,A����X���<Q�<���K8m(���g8����b="[N�Zp��N�6TB�T��A�r��U�~B'Y�-�&�H:��蔞�(tg��V�}w��
��J�dP�w�	��aK�H(o���Q�Z�������}�������P{skF��'Xq�W��oBM��t�I�i\a?X-���'W��(��j-K��s���6�Շ��>}[��hR΋��볼{�����[����oA�m�h;΋[��W;7�~%EV�J=[�0��U��������#�*�|&�v8�-��X�;� �?H��H�Ư��Y���"U�D*~�۝�,*#���I;͜pa�,=�
G����]~�+��#�vv�������k��V���xo��ܼ	<}���*a�v���� �.ظ0+5�܎P_0|	O����HIH=�|�2�>r��Í�I�ee [`v�䍁[�&�����nt�M��Ã�5�M�!u��}���!]u��RC&ν��`���!F�f��J���sw������8P�;�����K]?+M{o�;����.�!K[9F]i�b��b�Ʈ|��*��޽���'�,K\$�F�|��m>�C��|:��ћq�>Z�Cq�<U�D�w�@ ��3Ĕ���~���1C�4�+�d'��V�-����e0�HbƤv���HZ�bd]y+�	�<
����-d��`ȅ C V��vm��Ak7��~�(��y:���/t���A꼧�f�����!@ mL>���%���(ذ�t%�DPH�Ε�FN�ȱ�ݴ�~q�!w Yt�� 5gy���>�ZI�3�Icߵ�q�$��9!�/�7�����Y��`��"�|�8��A`o�*^!:���лQ1vKK��p3���#�G����B2F$R#�EB��@i� ��`���0g��W`L������x����Pʛ[� /qY�j�p��a�>t�N#^21e�9�|vWI��7������(�/oP�8e�緛I�|݋�;��$-������ǿ/6P[��{�4��&���>��uՂÒ��[�S�'FP�N�d1I�zC�(26j�Ehp��f^���]s����]���&�S���F�Տ��&��^��5��J��9Ã�4��Q�Q.��z0�\���A�x��Хz�&��p���@�K�v�.Ltj�S}�ؕj��nb҄#�8
����в\s��D�Cy��	��t�2�VѮIF(�J�y@R�O��.[aT�S.,������8��9�����!(Җ���TF�����5a�����6O��J���c��I&��"=/�w�)�vL}Al�A�2��������F#Ik��rm(\�`	��~
��pT�XG���T�ضq`ȳX��w'e�~�+,�N�,�����T�4��O�\%���ᑋ��6,�T�2䘘ᒮ��Ds�O�(<��nuS�?Jk���k�:5���ܰ�1�L���!�R��ʂ��:��P1gh�i�"����9�R�¯ �yAח����C��)~tb�Kܝ<ܤ���|�z�TI�:���1�4g��cg�<=�:�5��[����S��ȹk$j�%������NYq�� �K{j#�C�5�i
�ŌdIPL˜?ɋ�ɼ�R�Q��=MA��j\�
إ��w_�U�
������~��y����;�-�_.�������Zv(���9�y��g�m2*"w�)����os,�~N��#x��8à��V׏�m�0��-E��)���\TO/q�����_:4�x�_
Y��� ;s�G��z!��K��`����J��j&x>KS���ގ�=��D!ϖD�a���z��,�qL����σ��\+���bѾ	1�%g���<0�cWÙ(]�i5�;V� ������N2=�Y˓*m���,룃\a�������9pD])6s�#���/���< �N��18�9�	�H��)�)'rKl�}��#Y����?4l!���1?c&�H���~����b-�
159����J�n#��(!�=���&?����Y"8Z�py�l������aBh��|Α���1��%r(�#��#��ӷ�9<M΁^4Y�XZ����C���b��\�.���	����z^�0�\[��/��i*}O:!%̌\[��]Р�L̝
����%*�c�e�;;0u[����(,RN[��_�˙T϶�\P�¤�����U�^��H��.h�]|V���M�,�%�$X����$B��[Xc�=+IL=���m����~?��X���A�����WY=$���ˉ6[��x�~�coD����������;�S�H{�j���o��8�(���2*IҠ
bs�WYm<4W����?Ui��J<�	(��̗+]!����1����"�#�,8�6"���'}���K�D���A@m�L"��sWr�K    ��k^��@��~v�O%�(�>p�C6�C Xn8E&�U��	�,
K��ma��"]-0�4��W^Z�_ՉS�ӨD�#3�NE�Oj�aGv���
A�t��nlֶ���_�w��Ӻ�4�~^*ְ�;Y�0!AU&�!��Y{��A��>\0W���0o7|������
zx���%�rjH��ժ^�C�B路�nǖ�pH�-�3�����q���)��� ���S��yҒ ��Ґ�C�[����a��@8���݃�I��$'~S&>��R?O��ȭ\�6��<�A�c��#4�d�#�uP�~��^Eo\��KS;�m;�f��(�CO���h��/�l�s��!C�m�B����Nȭ��~��O@!������m[�<�o��3g��c�&J�[^��}�h�%����Q@3%WTY�p��bvE�
��(�[��S8.-B����n���M�U.ީ�Dj���)��v&�����z��s!�mj�W����[^:�*E%�`x����/�`�U�}2X�x�A���LVy��p�JL]��HA��1���D��r5\��8q�l�\$<H:P�潐�]�M<��A���b��k�K �H#���+�u�lLA����e|H�K����bO���Aߖ��7��@��a��255�Sb��ʜ��*Za\!���La~�r@N.�a�����|DA�@��b��"7����P�+��&o���f���o3UR�t^��DN���n�k���wI��τ	A��ē��/HgGZ�AT�>�y?9�V�� ����K�ɯ�ˊ.�.l{���O��M��,�N�m�D��8���|DE��#�Z��*Q�En�
��!�}o�?�����m$�S�.MP?P���YgwI��:�إ��
��+v��=�JS�d-T\���s��\�S���jUM��@��nS�( �^�����N^�~�=����\T��
X�Fsq�T\"��P�|(�R.����삷Y�U0U�7���m7���%�|�I��|��j�t�:x~�M]����t%�X_�}�aM2W�1���9���ML�>��Q$Ԃ�p�y�� !;$�W��<��DA�mՉ�u�۽���86�{���qL�k�Bkː{}B��\��%%}Uw���l�� ��#���#�mH9���a�s�I,�g��[/���^�p�K��WP���u�`;2���/��D}�;eV��%�-,j�t1�����cJ/"�p�
�Dx�өl'������ʤ�Bt*��gC���c����?WRd3�;����O���20����ǋdg �������W(�v�$�cs��\��|h�)������L�S&�3�8e��a���*�	��2 �_#ԅYzg5�)�����s�O:a���LEarqea���2FTy�O������>a�����|Qʕ�$���Ͼg�!�R^D A��pGA�"p�8�ܰ�kQ�Qe)�O<�F��Wz���9x�l�J�R�F]�	M]P
䕻?h)��N���e1|ѫ..z��-��#����bf5+�h��5��75��P~Fv/L� cU '�ԙ�H��ք�-mJ�2A������QΐD0-�M��
4X�0����� �����W5�9ed�]����+�=�Z;����˗d�v�����m��v�I ��I�ףجe�٤o��"֚��H��f:b}��M��(�<�\ "`�J?�x�\<�T�!֚g������:&ڼ�1��F��������1_����w��w���6�b#u3�c�� �u�F��6�ҋ�z�i���m��#�n�M���	L�_���/_�\���>���?ۜ��,%s �'#��-�Շ�G�����R,^�f�uJ���Vzs�v�݇5ZKȮeι6+-�_|�"ձ�}�;#�%�3zVط?Oא���!��b���j�"n�����k�F��~�L����L���5�C������g���`qWq(H�Ia9����H����W�݇�Re�R��d�F�`�Cj[��`+�����_^�*���0P��%'*�q<'Y�D{(fq}�Vl 5nȘ����r$C|��)
�n9�224ǎ�\Z�lw�O�S*y,�TZ�,Z��ˁ�S�_����wI����X�9'��v@�[�-6V7�N��C�8`�s-{���	Swy����=~)Py��u�$u(��~*�Q�TZ�-�x(�WȪ���-�a�$g�:H Ͱfzfں�^go�Fү�r�&IAKԏG��t04M�x�bj�GC���=�6CJ�K��&�+�uSm�w����`�@���e���#�P��:�]OE���UP`���v\懔Q@�mm�.Go����z5	֣m��ݵF��c2�+1vҦGgP�DY]�xB����]��C{�_��:׾��v�!s�sXW��Cu�	��!mVw�h+���G�����WQS\����
��������5�$�W�Xzd>/82Zq����x-���4��q�_B��Z\�n@���sH��+���ߒ�1�5�N�����a����_fybE�ڃ��l&����+�e�����2$��pG�]G�7�9�L�mG��6���0���Y��������h��odR��_iII�D`%�dBl��e��8�O~hN�o�2.�R�Sb~���R/��Cka�����w��dm�[���Q�����y}������A��o,;�m�Д�e�3}� �(|�c>�qm���(eN!�,1.8I��Ժ�mf��N��q��!T�.�ZnHB�\������1��Υ���b����I����@�%f?
;HRgg�����6QaS��(�I�fx+���Z:���[RIt�ן,%{.�ے���6)��;d�ӡ��X��V�VfS�@��穛��=�R�+A���Pwޅ�2az�T�
-L�&�	�N<Hq#�20]�3�0rG~�y�0�ݕ�dB8�W1Ro�V�0�O���B�4I�?�����X�]�{��'A�}K��)$�+�ZsX.��F��^v6�FD�0���I�ot,�eZ�Ay���y�s!��s��y�-���[ui�$��-G ��׊��!�>���t�4'ŭ��h"}�{ʾ8�;�������^>�I���(�̍ڈ2����^�Ё"�ɜ�jJ��L�5���u�(�|�K��o8�VfJ���������؜�n!����6�[��3����k�Y��S��,�Sm9�h�<�Ml�d w�X�M�b��<��^l�S�{Ǆ��$��@�sS=EH�$�p\\�}����n��k�Tm^Q��.f����HU?M6\:�i�|�/d[�[QS]?W�2�Gc�������&�R�z*��$���K�'&]D�mñ�K��Zd�|��Ɩ��P���X���p_*���ث1}�׻;-�*uW>���{$m���EZQT>���B
jD�	ܽ����2k��5@�� ��:�
�T9h���xͨA72��1��Zڔ]nʼ�O8r�{@��q�~cZ$#�k%[Dt�~Hզ�́/9����v�l�f�mH�1�b�<��<��	8�Dw����c;W-���\�Ns=� ���1a#����b�~%_5l�UP���8���*#$��gE�Y��~� �j��Ɏ�u�^��D�
u�G��q�k�V?9sx'�|��$1?�����ĩW��b-;��Mpk��-��wh�2��`��"�U�I�9/u]l�%\�f2�I7wޕ�Z�F�����{�Z.���67)����=���I�c��K���gM��</1��e��C�K��
��dZH[%�N3��2U�z�ګ�����3���E����:�61�KSGs�!�l�]�9��vA@�s5'|�X�t^0����y4�|�!�T�w��Cf3U�J*Bc�tk��1��㎕�oԟP;�	�v�R�F�bJ��w�\E;����A0"�_�����|� Ѣ��K�_K��G��me�!���=i
V(<�ۑl3���O���]�� *  �^��ʧ�G�C)���!z��>2�K��$�"}]q�|�9g��
��x����J/��x`N/c�_![Pc�Hi���/6�������lP��12�߈꼍3�k~�X �L�qVA�*~9�u9��8�V[�i��81�O`Ig��S��7v�#7�&WQp�+W�[Q0�y���!�s#�+�T	�~����ςG3��t������q��^�k.�82��vi��-i}k���_wĭ��Ő���3np��7K��Z��gg�V�WŦb ܾ~�'��-�c�r��OB�1��MT�9}3�pyS���_t \�L��H̉S�o��������)� @Bg��m&��L�S��N�{d-�.Ki�g�������n���	v=��Up��R�.��F�������yx��km���i#szMvw�b�昽"��m����ρd�K���V"܂O,�3�r����J\�S�zZ2Q���sY� Fub�k��<��m�e�U�ٳ�3S�H�)�Q*?ۙٮ�[�%{/������Q�RT�����n��ˎ"���E6!�u�|a�G
�/8�v[ )��䴼�CV�ê��F��sX����g�y50=h!��o|�����ړ�Qo�/��肰J$_���e����U��F����^()Eqqs%�{�p�QV�zQ�e ���������i�ooI*��T:�۽
�hI)�Ư��Q�3¯܅ɩ(r�3�ߩ%JT.٨��/"��mI�Cy�t�B��X��OQ�Nbp�񷌁g��C������n؁^n�����A޸E\��`�.�s�� @���w��M(5��'���p��U�
6�#o�1B�e����7|v�5��-a+�&Ox�R}y�F i/���z^��cae�Ձ��~���� %V�����2u7A!|�]���$ojn�f��C7z<��ݢu�~�������Q����A�ֶh����|J���E�赈�]Ӫa��$U��N)a�W^Pvh�(��	���ڈB�-(0��M��*
~���u)]�@���"Q�n9i����!�~�j��J�&p���iV"�ޡFw=5�h�!��qO_�U�0�T�!Ӹ^���.͆�+C,yMkK���F;�[����_׻!�swt[�+��<�����nE/P�u�tgt_x�P��o;�o�]@��C��}��)���˙l��E�V͓�O����>���O�VVnқS�d����.�u�VX��||�8��Q�v!xW����^p�R��m�rs���D�R�E"v�&=N:E+k��ܷ�'�j3хcZ�pQ�C�#�}�<��-�6�g@�)�)�[t�V�r�a���v����3�iK�Dkͅk������1󉱽�C���Y�U�9B���m��e����X�r���r��5���6|�d�
c%��On�2��f2����Y����d�DT=5�4<�'IO�	���v��D�9R$�+������v~kx��`Ԝ� �vd��m>�O��<L���ƾ��U��ւvr����P �ܪUPia�=�xk�$G]���?��%	�:��Vn�9���|0��86�����e!0�Ŵ���4m�RC}�:�F�D/����Vz�d�\�\^y0��v�7�C�!�{9�t���!��6��`oD��� 0!^��~$���̐���<Y�~>��4�LL�)7k�Ƙ��P.Xt�mM(f��NgK��}f�Gw��{�d�XL5�~���p\/H_W���L�͗�g�#:ꖲ��R���>�m$U�95��?Y�mR�`���>OF�*^�w�rZn�w� ���.|�V�Se�ϔ���⇮$n|�8݄����CK�� 4�SS7�}�����y�c���)�I�VTZ8ha�ϊSJ59�������Q^��D��ᗇ�� �_�5�Z-��	j��/���D�f_��5f�{�J��Ļ^{�,�g�&ۛ�s*2�B��=��JP-����d�����S�-���S�O�}�=�A�̀��\s)~����D�/��/a	x>�c�ץ9�`�À���w�y�+��,O�r>e�v[Q��~~NT�S99��"o�h�Xd���<�	iϵ�E�Q�G���)V�Gf�N��b�q&۶F}Z�N�~��Ldq*�T3��A�(��o�Ö<��I���m� ��^�� �o�J�{[P�Lj.��8utz�e�St@�ه�!�#y�C�p�W�g��\��Q(=�S��eC2��^\�	h�o"Q��F4PCF ��?�|���l�8�\xlF�u��
3Ao�OI��QªM�qo�Ț3� h?GՋ/I����*���Q��!� �)pY�8�����t4�{��%��	 �~u�����*�J���:Ձrl(J��Q�w3Wi�*��vq�<��R�\�)jI՚K2L�i���,*쾈�?$;�|#���`��{�2��g2���i���w���<�VO�QD@$��UȔ>�"�d�n��~�����L���7��i����WS·7������E�!�W�cLs.�B���0�#�mWk���g��'V�b���C
H+E��Q^(��B�FV�I�kX��c�1�ǳ�c�\��tM�� �I��mFq��ׇ����>�jG�Ϝ+�I�[�������j�jnt픷mR�Vp�k����w��0�K�!�31�3�8��O��\	����]��}gIOǑ��4%׽�(̰IQC%@J�د'8!Y2�*�D/C�6��r�2hy�Z�!y�\U�*�JA�f�&؉B��r
�<�
Vnf�p�Z��W��0a5O�A���I�)��w?��KAZ�Dd�l1)�$m��H�*!�T[n��*��۶4WE �4���U��_�چ��f"��dCO�����~�9��%��x2���P�6�;�!�+�b a7*ae���ϵ�άߛ��9����z"Q��	����l�d��4uZ�řWw��?5�'[�6<K�%T�l�)�\�҈�2}�#3Pn�m�K�	O���[7�jL�<xŇ�}C�ڣ����mQ�ֹ�x#�i��)��m�����l���p[�jM�������,�ļ)��B�d����0��{{��yK��tF3�W��/`���s�r��y/�2ļ�#�k�|�*�`49���#V&������������S\������h�Tr[TNW���g��=E�������R�B���A���Ͷ�.H� Tѝ�����{�Gѭ�xr+��db�HK�ܵ{�|ͨ��	��.�/\�����l�s��;������      �
      x��H35H65L66M1����� +�     