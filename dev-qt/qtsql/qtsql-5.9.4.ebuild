# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="SQL abstraction library for the Qt5 tooolkit"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples freetds mysql oci8 odbc postgres +sqlite"

REQUIRED_USE="
	|| ( freetds mysql oci8 odbc postgres sqlite )
"

# TODO: multilib for freetds and postgres
DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	freetds? ( dev-db/freetds )
	mysql? ( virtual/libmysqlclient:=[${MULTILIB_USEDEP}] )
	oci8? ( dev-db/oracle-instantclient-basic[${MULTILIB_USEDEP}] )
	odbc? ( || ( dev-db/unixODBC[${MULTILIB_USEDEP}] dev-db/libiodbc[${MULTILIB_USEDEP}] ) )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3.8.10.2:3[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/sql
	src/plugins/sqldrivers
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:sql
)

multilib_src_configure() {
	local myconf=(
		$(qt_use freetds  sql-tds    plugin)
		$(qt_use mysql    sql-mysql  plugin)
		$(qt_use oci8     sql-oci    plugin)
		$(qt_use odbc     sql-odbc   plugin)
		$(qt_use postgres sql-psql   plugin)
		$(qt_use sqlite   sql-sqlite plugin)
		$(usex sqlite -system-sqlite '')
	)

	use mysql && myconf+=("-I${EPREFIX}/usr/include/mysql" "-L${EPREFIX}/usr/$(get_libdir)/mysql")
	use oci8 && myconf+=("-I${ORACLE_HOME}/include" "-L${ORACLE_HOME}/$(get_libdir)")
	use odbc && myconf+=("-I${EPREFIX}/usr/include/iodbc")
	use postgres && myconf+=("-I${EPREFIX}/usr/include/postgresql/pgsql")

	qt5_multilib_src_configure
}
